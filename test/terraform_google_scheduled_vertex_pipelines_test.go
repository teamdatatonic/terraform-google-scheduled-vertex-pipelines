package terraform_google_scheduled_vertex_pipelines_test

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

		// Missing variables will come from TF_VAR env variables

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

func TestHelloWorldGCS(t *testing.T) {

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Directory where main.tf for test is
		TerraformDir: "../examples/hello_world_gcs",

		// Missing variables will come from TF_VAR env variables

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
