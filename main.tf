terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
}

locals {
  # var.pipeline_spec_path minus gs:// prefix (if prefix exists)
  pipeline_spec_path_no_gcs_prefix = trimprefix(var.pipeline_spec_path, "gs://")

  # is var.pipeline_spec_path a GCS path? (i.e. has trimming the prefix made a difference?)
  pipeline_spec_path_is_gcs_path = (var.pipeline_spec_path != local.pipeline_spec_path_no_gcs_prefix)

  # split the path into parts by "/"
  pipeline_spec_path_no_gcs_prefix_parts = split("/", local.pipeline_spec_path_no_gcs_prefix)

  # Load the pipeline spec from YAML/JSON
  # If it's a GCS path, load it from the GCS object content
  # If it's a local path, load from the local file
  pipeline_spec = yamldecode(local.pipeline_spec_path_is_gcs_path ? data.google_storage_bucket_object_content.pipeline_spec[0].content : file(var.pipeline_spec_path))

  # If var.kms_key_name is provided, construct the encryption_spec object
  encryption_spec = (var.kms_key_name == null) ? null : {"kmsKeyName": var.kms_key_name}

  # Construct the PipelineJob object
  # https://cloud.google.com/vertex-ai/docs/reference/rest/v1/projects.locations.pipelineJobs
  pipeline_job = {
      displayName = var.display_name
      pipelineSpec = local.pipeline_spec
      labels = var.labels
      runtimeConfig = {
          parameterValues = var.parameter_values
          gcsOutputDirectory = var.gcs_output_directory

      }
      encryptionSpec = local.encryption_spec
      serviceAccount = var.vertex_service_account_email
      network = var.network

  }

}

# If var.pipeline_spec_path is a GCS path
# Load the pipeline spec from the GCS path
data "google_storage_bucket_object_content" "pipeline_spec" {
  count = local.pipeline_spec_path_is_gcs_path ? 1 : 0
  name = join("/", slice(local.pipeline_spec_path_no_gcs_prefix_parts, 1, length(local.pipeline_spec_path_no_gcs_prefix_parts)))
  bucket = local.pipeline_spec_path_no_gcs_prefix_parts[0]
}

# If a service account is not specified for Cloud Scheduler, use the default compute service account
data "google_compute_default_service_account" "default" {
    count = (var.cloud_scheduler_sa_email == null) ? 1 : 0
    project = var.project
}

resource "google_cloud_scheduler_job" "job" {
  name             = var.cloud_scheduler_job_name
  project          = var.project
  description      = var.cloud_scheduler_job_description
  schedule         = var.schedule
  time_zone        = var.time_zone
  attempt_deadline = var.cloud_scheduler_job_attempt_deadline
  region           = var.cloud_scheduler_region

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    uri         = "https://${var.vertex_region}-aiplatform.googleapis.com/v1/projects/${var.project}/locations/${var.vertex_region}/pipelineJobs"
    body        = base64encode(jsonencode(local.pipeline_job))

    oauth_token {
      service_account_email = (var.cloud_scheduler_sa_email == null) ? data.google_compute_default_service_account.default[0].email : var.cloud_scheduler_sa_email
    }

  }
}
