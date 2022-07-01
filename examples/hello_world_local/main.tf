module "hello_world_pipeline" {
  source                 = "../../"
  project                = var.project
  vertex_region          = var.vertex_region
  cloud_scheduler_region = var.cloud_scheduler_region
  pipeline_spec_path     = var.pipeline_spec_path
  parameter_values = {
    "text" = "Hello, world!"
  }
  gcs_output_directory         = var.gcs_output_directory
  vertex_service_account_email = var.vertex_service_account_email
  time_zone                    = "UTC"
  schedule                     = "0 0 * * *"
  cloud_scheduler_sa_email     = var.cloud_scheduler_sa_email
  cloud_scheduler_job_name     = var.cloud_scheduler_job_name

}
