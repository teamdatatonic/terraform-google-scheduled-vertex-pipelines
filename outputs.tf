output "id" {
  value       = google_cloud_scheduler_job.job.id
  description = "an identifier for the Cloud Scheduler job resource with format projects/{{project}}/locations/{{region}}/jobs/{{name}}"
}
