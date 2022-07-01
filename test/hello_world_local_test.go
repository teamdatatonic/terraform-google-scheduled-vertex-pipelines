package hello_world_local_test

import (
	"context"
	"testing"

	scheduler "cloud.google.com/go/scheduler/apiv1beta1"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	schedulerpb "google.golang.org/genproto/googleapis/cloud/scheduler/v1beta1"
)

func TestHelloWorldLocal(t *testing.T) {

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Directory where main.tf for test is
		TerraformDir: "../examples/hello_world_local",

		// Variables to pass to our Terraform code using -var options
		// Missing variables (project_id) will come from TF_VAR env variables
		Vars: map[string]interface{}{
			"pipeline_spec_path":           "pipeline.json",
			"time_zone":                    "UTC",
			"schedule":                     "0 0 1 1 *",
			"cloud_scheduler_job_name":     "test-local-pipeline-definition",
			"vertex_service_account_email": "vertex-pipeline-runner@my_project.iam.gserviceaccount.com",
			"gcs_output_directory":         "gs://my_bucket/pipeline_root",
			"vertex_region":                "europe-west2",
			"cloud_scheduler_region":       "europe-west2",
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Get cloud scheduler job ID from terraform output
	cloud_scheduler_job_id := terraform.Output(t, terraformOptions, "id")

	// set up Google Cloud SDK connection
	ctx := context.Background()
	c, _ := scheduler.NewCloudSchedulerClient(ctx)
	defer c.Close()

	// Get cloud scheduler job using Google Cloud SDK
	req := &schedulerpb.GetJobRequest{
		Name: cloud_scheduler_job_id,
	}
	resp, _ := c.GetJob(ctx, req)

	// Assert Cloud Scheduler job exists and is enabled
	assert.Equal(t, schedulerpb.Job_ENABLED, resp.State)

}
