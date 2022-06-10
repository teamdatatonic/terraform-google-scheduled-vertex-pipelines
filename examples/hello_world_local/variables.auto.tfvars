project = "my-gcp-project-id"
region = "europe-west2"
pipeline_spec_path = "pipeline.json"
parameter_values = {
  "text" = "Hello, world!"
}
gcs_output_directory = "gs://my-bucket/my-output-directory"
vertex_service_account_email = "my-vertex-service-account@my-gcp-project-id.iam.gserviceaccount.com"
time_zone = "UTC"
schedule = "0 0 * * *"
cloud_scheduler_sa_email = "my-cloud-scheduler-service-account@my-gcp-project-id.iam.gserviceaccount.com"
cloud_scheduler_job_name = "my-first-pipeline"
