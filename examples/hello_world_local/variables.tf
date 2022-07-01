variable "project" {
  type        = string
  description = "The GCP project ID where the cloud scheduler job and Vertex Pipeline should be deployed."
}

variable "vertex_region" {
  type        = string
  description = "The GCP region where the Vertex Pipeline should be executed."
}

variable "cloud_scheduler_region" {
  type        = string
  description = "The GCP region where the Cloud Scheduler job should be executed."
}

variable "pipeline_spec_path" {
  type        = string
  description = "Path to the KFP pipeline spec file (YAML or JSON). This can be a local or a GCS path."
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "The labels with user-defined metadata to organize PipelineJob. Label keys and values can be no longer than 64 characters (Unicode codepoints), can only contain lowercase letters, numeric characters, underscores and dashes. International characters are allowed. See https://goo.gl/xmQnxf for more information and examples of labels."
}

variable "parameter_values" {
  type        = map(any)
  default     = {}
  description = "The runtime parameters of the PipelineJob. The parameters will be passed into PipelineJob.pipeline_spec to replace the placeholders at runtime. This field is used by pipelines built using PipelineJob.pipeline_spec.schema_version 2.1.0, such as pipelines built using Kubeflow Pipelines SDK 1.9 or higher and the v2 DSL."
}

variable "gcs_output_directory" {
  type        = string
  description = "Required. A path in a Cloud Storage bucket, which will be treated as the root output directory of the pipeline. It is used by the system to generate the paths of output artifacts. The artifact paths are generated with a sub-path pattern {job_id}/{taskId}/{output_key} under the specified output directory. The service account specified in this pipeline must have the storage.objects.get and storage.objects.create permissions for this bucket."
}

variable "vertex_service_account_email" {
  type        = string
  default     = null
  description = "The service account that the pipeline workload runs as. If not specified, the Compute Engine default service account in the project will be used. See https://cloud.google.com/compute/docs/access/service-accounts#default_service_account. Users starting the pipeline must have the iam.serviceAccounts.actAs permission on this service account."
}

variable "time_zone" {
  type        = string
  default     = "UTC"
  description = "Specifies the time zone to be used in interpreting schedule. The value of this field must be a time zone name from the tz database."
}

variable "schedule" {
  type        = string
  description = "Describes the schedule on which the job will be executed."
}

variable "cloud_scheduler_sa_email" {
  type        = string
  default     = null
  description = "Service account email to be used for executing the Cloud Scheduler job. The service account must be within the same project as the job."
}

variable "cloud_scheduler_job_name" {
  type        = string
  description = "The name of the Cloud Scheduler job."
}
