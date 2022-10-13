module "hello_world_pipeline" {
  source                 = "../../"
  project                = var.project
  vertex_region          = "europe-west2"
  cloud_scheduler_region = "europe-west2"
  pipeline_spec_path     = var.pipeline_spec_path
  parameter_values = {
    "text" = "Hello, world!"
  }
  gcs_output_directory         = "gs://my-bucket/my-output-directory"
  vertex_service_account_email = "my-vertex-service-account@my-gcp-project-id.iam.gserviceaccount.com"
  time_zone                    = "UTC"
  schedule                     = "0 0 * * *"
  cloud_scheduler_job_name     = "pipeline-from-local-spec"

}
