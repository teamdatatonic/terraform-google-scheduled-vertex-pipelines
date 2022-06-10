<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloud_scheduler_job.job](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_scheduler_job) | resource |
| [google_compute_default_service_account.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_default_service_account) | data source |
| [google_storage_bucket_object_content.pipeline_spec](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket_object_content) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_scheduler_job_attempt_deadline"></a> [cloud\_scheduler\_job\_attempt\_deadline](#input\_cloud\_scheduler\_job\_attempt\_deadline) | The deadline for Cloud Scheduler job attempts. If the request handler does not respond by this deadline then the request is cancelled and the attempt is marked as a DEADLINE\_EXCEEDED failure. The failed attempt can be viewed in execution logs. Cloud Scheduler will retry the job according to the RetryConfig. The allowed duration for this deadline is between 15 seconds and 30 minutes. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s" | `string` | `"320s"` | no |
| <a name="input_cloud_scheduler_job_description"></a> [cloud\_scheduler\_job\_description](#input\_cloud\_scheduler\_job\_description) | A human-readable description for the Cloud Scheduler job. This string must not contain more than 500 characters. | `string` | `null` | no |
| <a name="input_cloud_scheduler_job_name"></a> [cloud\_scheduler\_job\_name](#input\_cloud\_scheduler\_job\_name) | The name of the Cloud Scheduler job. | `string` | n/a | yes |
| <a name="input_cloud_scheduler_region"></a> [cloud\_scheduler\_region](#input\_cloud\_scheduler\_region) | The GCP region where the Cloud Scheduler job should be executed. | `string` | n/a | yes |
| <a name="input_cloud_scheduler_retry_count"></a> [cloud\_scheduler\_retry\_count](#input\_cloud\_scheduler\_retry\_count) | The number of attempts that the system will make to run a Cloud Scheduler job using the exponential backoff procedure described by maxDoublings. Values greater than 5 and negative values are not allowed. | `number` | `1` | no |
| <a name="input_cloud_scheduler_sa_email"></a> [cloud\_scheduler\_sa\_email](#input\_cloud\_scheduler\_sa\_email) | Service account email to be used for executing the Cloud Scheduler job. The service account must be within the same project as the job. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name of the Pipeline. The name can be up to 128 characters long and can be consist of any UTF-8 characters. | `string` | `null` | no |
| <a name="input_gcs_output_directory"></a> [gcs\_output\_directory](#input\_gcs\_output\_directory) | Required. A path in a Cloud Storage bucket, which will be treated as the root output directory of the pipeline. It is used by the system to generate the paths of output artifacts. The artifact paths are generated with a sub-path pattern {job\_id}/{taskId}/{output\_key} under the specified output directory. The service account specified in this pipeline must have the storage.objects.get and storage.objects.create permissions for this bucket. | `string` | n/a | yes |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | The Cloud KMS resource identifier of the customer managed encryption key used to protect a resource. Has the form: projects/my-project/locations/my-region/keyRings/my-kr/cryptoKeys/my-key. The key needs to be in the same region as the Vertex Pipeline execution. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | The labels with user-defined metadata to organize PipelineJob. Label keys and values can be no longer than 64 characters (Unicode codepoints), can only contain lowercase letters, numeric characters, underscores and dashes. International characters are allowed. See https://goo.gl/xmQnxf for more information and examples of labels. | `map(string)` | `{}` | no |
| <a name="input_network"></a> [network](#input\_network) | The full name of the Compute Engine network to which the Pipeline Job's workload should be peered. For example, projects/12345/global/networks/myVPC. Format is of the form projects/{project}/global/networks/{network}. Where {project} is a project number, as in 12345, and {network} is a network name. Private services access must already be configured for the network. Pipeline job will apply the network configuration to the GCP resources being launched, if applied, such as Vertex AI Training or Dataflow job. If left unspecified, the workload is not peered with any network. | `string` | `null` | no |
| <a name="input_parameter_values"></a> [parameter\_values](#input\_parameter\_values) | The runtime parameters of the PipelineJob. The parameters will be passed into PipelineJob.pipeline\_spec to replace the placeholders at runtime. This field is used by pipelines built using PipelineJob.pipeline\_spec.schema\_version 2.1.0, such as pipelines built using Kubeflow Pipelines SDK 1.9 or higher and the v2 DSL. | `map(any)` | `{}` | no |
| <a name="input_pipeline_spec_path"></a> [pipeline\_spec\_path](#input\_pipeline\_spec\_path) | Path to the KFP pipeline spec file (YAML or JSON). This can be a local or a GCS path. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The GCP project ID where the cloud scheduler job and Vertex Pipeline should be deployed. | `string` | n/a | yes |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | Describes the schedule on which the job will be executed. | `string` | n/a | yes |
| <a name="input_time_zone"></a> [time\_zone](#input\_time\_zone) | Specifies the time zone to be used in interpreting schedule. The value of this field must be a time zone name from the tz database. | `string` | `"UTC"` | no |
| <a name="input_vertex_region"></a> [vertex\_region](#input\_vertex\_region) | The GCP region where the Vertex Pipeline should be executed. | `string` | n/a | yes |
| <a name="input_vertex_service_account_email"></a> [vertex\_service\_account\_email](#input\_vertex\_service\_account\_email) | The service account that the pipeline workload runs as. If not specified, the Compute Engine default service account in the project will be used. See https://cloud.google.com/compute/docs/access/service-accounts#default_service_account. Users starting the pipeline must have the iam.serviceAccounts.actAs permission on this service account. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | an identifier for the Cloud Scheduler job resource with format projects/{{project}}/locations/{{region}}/jobs/{{name}} |
<!-- END_TF_DOCS -->
