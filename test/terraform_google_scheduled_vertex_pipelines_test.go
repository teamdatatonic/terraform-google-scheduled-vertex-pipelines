package terraform_google_scheduled_vertex_pipelines_test

import (
	"context"
	"testing"

	scheduler "cloud.google.com/go/scheduler/apiv1beta1"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	schedulerpb "google.golang.org/genproto/googleapis/cloud/scheduler/v1beta1"
	"google.golang.org/grpc/codes"
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

	// Trigger Cloud Scheduler job and assert no errors
	req2 := &schedulerpb.RunJobRequest{
		Name: cloud_scheduler_job_id,
	}

	resp2, err := c.RunJob(ctx, req2)

	assert.Equal(t, nil, err)
	assert.Equal(t, codes.OK, resp2.Status.Code)

}

func TestHelloWorldNestedPipelineSpecLocal(t *testing.T) {

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Directory where main.tf for test is
		TerraformDir: "../examples/hello_world_local",

		Vars: map[string]interface{}{
			"pipeline_spec_path": "../../test/pipeline_nested_pipelinespec.json",
		},

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

	// Trigger Cloud Scheduler job and assert no errors
	req2 := &schedulerpb.RunJobRequest{
		Name: cloud_scheduler_job_id,
	}

	// resp2, err := c.RunJob(ctx, req2)
	resp2, err := c.RunJob(ctx, req2)

	assert.Equal(t, nil, err)
	assert.Equal(t, codes.OK, resp2.Status.Code)

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

func TestHelloWorldAR(t *testing.T) {

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Directory where main.tf for test is
		TerraformDir: "../examples/hello_world_ar",

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
