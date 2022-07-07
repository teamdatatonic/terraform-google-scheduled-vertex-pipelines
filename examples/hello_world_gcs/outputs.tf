output "id" {
  value       = module.hello_world_pipeline.id
  description = "an identifier for the Cloud Scheduler job resource with format projects/{{project}}/locations/{{region}}/jobs/{{name}}"
}
