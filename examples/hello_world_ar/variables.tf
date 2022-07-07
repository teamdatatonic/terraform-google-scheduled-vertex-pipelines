variable "project" {
  type        = string
  description = "The GCP project ID where the cloud scheduler job and Vertex Pipeline should be deployed."
}

variable "ar_repository" {
  type        = string
  description = "Name of the Artifact Registry repository used to store the pipeline definition."
}
