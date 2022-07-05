variable "project" {
  type        = string
  description = "The GCP project ID where the cloud scheduler job and Vertex Pipeline should be deployed."
}

variable "gcs_bucket" {
  type        = string
  description = "Name of the GCS bucket used to store the pipeline definition."
}

variable "object_name" {
  type        = string
  description = "Name of the object to be stored in GCS (pipeline definition)."
}
