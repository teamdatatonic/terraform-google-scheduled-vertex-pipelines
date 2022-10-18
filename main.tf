terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }

    http = {
      source  = "hashicorp/http"
      version = ">= 2.2.0"
    }
  }
}

locals {
  # Regex explanation:

  # Starts with named group "scheme"
  # either "https://" ("http_scheme") (for Artifact registry pipeline spec)
  # or "gs://" ("gs://") (for GCS pipeline spec)
  # or nothing

  # Next part is named group "root"
  # For GCS path "root" = bucket name
  # otherwise it's just the first part of the path (minus prefix)

  # Next named group is "rest_of_path_including_slash"
  # This consists of two named groups:
  # 1) a forward slash (named group "slash")
  # 2) rest of the string (named group "rest_of_path")
  # For GCS pipeline spec "rest_of_path" = GCS object name
  pipeline_spec_path = regex("^(?P<scheme>(?P<http_scheme>https\\:\\/\\/)|(?P<gs_scheme>gs\\:\\/\\/))?(?P<root>[\\w.-]*)?(?P<rest_of_path_including_slash>(?P<slash>\\/)(?P<rest_of_path>.*))*", var.pipeline_spec_path)

  pipeline_spec_path_is_gcs_path = local.pipeline_spec_path.scheme == "gs://"
  pipeline_spec_path_is_ar_path  = local.pipeline_spec_path.scheme == "https://"

  # Load the pipeline spec from YAML/JSON
  # If it's a GCS path, load it from the GCS object content
  # If it's an AR path, load it from Artifact registry
  # If it's a local path, load from the local file
  pipeline_json = yamldecode(
    local.pipeline_spec_path_is_gcs_path ? data.google_storage_bucket_object_content.pipeline_spec[0].content :
    (local.pipeline_spec_path_is_ar_path ? data.http.pipeline_spec[0].response_body :
  file(var.pipeline_spec_path)))

  # Look up pipelineSpec from the compiled pipeline definition
  # Sometimes the pipelineSpec is the root component, sometimes it is a key within the root component
  pipeline_spec = lookup(local.pipeline_json, "pipelineSpec", local.pipeline_json)

  # Merge runtime config from file + terraform vars here
  # Terraform vars take priority
  runtime_config = merge(
    lookup(local.pipeline_json, "runtimeConfig", {}), # Sometimes runtimeConfig is in the pipeline JSON/YAML, sometimes not
    (var.parameters != null ? { "parameters" : var.parameters } : {}),
    (var.parameter_values != null ? { "parameterValues" : var.parameter_values } : {}),
    { "gcsOutputDirectory" : var.gcs_output_directory },
  )

  # If var.kms_key_name is provided, construct the encryption_spec object
  encryption_spec = (var.kms_key_name == null) ? null : { "kmsKeyName" : var.kms_key_name }

  # Construct the PipelineJob object
  # https://cloud.google.com/vertex-ai/docs/reference/rest/v1/projects.locations.pipelineJobs
  pipeline_job = {
    displayName    = var.display_name
    pipelineSpec   = local.pipeline_spec
    labels         = var.labels
    runtimeConfig  = local.runtime_config
    encryptionSpec = local.encryption_spec
    serviceAccount = var.vertex_service_account_email
    network        = var.network
  }

}

# If var.pipeline_spec_path is a GCS path
# Load the pipeline spec from the GCS path
data "google_storage_bucket_object_content" "pipeline_spec" {
  count  = local.pipeline_spec_path_is_gcs_path ? 1 : 0
  name   = local.pipeline_spec_path.rest_of_path
  bucket = local.pipeline_spec_path.root
}

# If var.pipeline_spec_path is an Artifact Registry (https) path
# We will need the authorization token
data "google_client_config" "default" {
  count = local.pipeline_spec_path_is_ar_path ? 1 : 0
}

# If var.pipeline_spec_path is an Artifact Registry (https) path
# Load the pipeline spec from AR (over HTTPS) using authorization token
data "http" "pipeline_spec" {
  count = local.pipeline_spec_path_is_ar_path ? 1 : 0
  url   = var.pipeline_spec_path

  request_headers = {
    Authorization = "Bearer ${data.google_client_config.default[0].access_token}"
  }
}

# If a service account is not specified for Cloud Scheduler, use the default compute service account
data "google_compute_default_service_account" "default" {
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
    retry_count = var.cloud_scheduler_retry_count
  }

  http_target {
    http_method = "POST"
    uri         = "https://${var.vertex_region}-aiplatform.googleapis.com/v1/projects/${var.project}/locations/${var.vertex_region}/pipelineJobs"
    body        = base64encode(jsonencode(local.pipeline_job))

    oauth_token {
      service_account_email = (var.cloud_scheduler_sa_email == null) ? data.google_compute_default_service_account.default.email : var.cloud_scheduler_sa_email
    }

  }
}
