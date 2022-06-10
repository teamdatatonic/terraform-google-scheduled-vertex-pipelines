module "hello_world_pipeline" {
  source                       = "../../"
  project                      = var.project
  vertex_region                = var.region
  cloud_scheduler_region       = var.region
  pipeline_spec_path           = var.pipeline_spec_path
  parameter_values             = var.parameter_values
  gcs_output_directory         = var.gcs_output_directory
  vertex_service_account_email = var.vertex_service_account_email
  time_zone                    = var.time_zone
  schedule                     = var.schedule
  cloud_scheduler_sa_email     = var.cloud_scheduler_sa_email
  cloud_scheduler_job_name     = var.cloud_scheduler_job_name

}
