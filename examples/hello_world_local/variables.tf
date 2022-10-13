variable "project" {
  type        = string
  description = "The GCP project ID where the cloud scheduler job and Vertex Pipeline should be deployed."
}

variable "pipeline_spec_path" {
  type        = string
  description = "Path to compiled pipeline.json"
  default     = "pipeline.json"
}
