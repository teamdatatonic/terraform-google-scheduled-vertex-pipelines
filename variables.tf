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

variable "display_name" {
  type        = string
  default     = null
  description = "The display name of the Pipeline. The name can be up to 128 characters long and can be consist of any UTF-8 characters."
}

variable "pipeline_spec_path" {
  type        = string
  description = "Path to the KFP pipeline spec file (YAML or JSON). This can be a local file, GCS path, or Artifact Registry path."
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

variable "kms_key_name" {
  type        = string
  default     = null
  description = "The Cloud KMS resource identifier of the customer managed encryption key used to protect a resource. Has the form: projects/my-project/locations/my-region/keyRings/my-kr/cryptoKeys/my-key. The key needs to be in the same region as the Vertex Pipeline execution."
}

variable "network" {
  type        = string
  default     = null
  description = "The full name of the Compute Engine network to which the Pipeline Job's workload should be peered. For example, projects/12345/global/networks/myVPC. Format is of the form projects/{project}/global/networks/{network}. Where {project} is a project number, as in 12345, and {network} is a network name. Private services access must already be configured for the network. Pipeline job will apply the network configuration to the GCP resources being launched, if applied, such as Vertex AI Training or Dataflow job. If left unspecified, the workload is not peered with any network."
}

variable "cloud_scheduler_job_name" {
  type        = string
  description = "The name of the Cloud Scheduler job."
}

variable "cloud_scheduler_job_description" {
  type        = string
  default     = null
  description = "A human-readable description for the Cloud Scheduler job. This string must not contain more than 500 characters."
}

variable "cloud_scheduler_job_attempt_deadline" {
  type        = string
  default     = "320s"
  description = "The deadline for Cloud Scheduler job attempts. If the request handler does not respond by this deadline then the request is cancelled and the attempt is marked as a DEADLINE_EXCEEDED failure. The failed attempt can be viewed in execution logs. Cloud Scheduler will retry the job according to the RetryConfig. The allowed duration for this deadline is between 15 seconds and 30 minutes. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: \"3.5s\""
}

variable "cloud_scheduler_retry_count" {
  type        = number
  default     = 1
  description = "The number of attempts that the system will make to run a Cloud Scheduler job using the exponential backoff procedure described by maxDoublings. Values greater than 5 and negative values are not allowed."
}
