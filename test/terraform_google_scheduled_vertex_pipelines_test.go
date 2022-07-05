package terraform_google_scheduled_vertex_pipelines_test

import (
	"context"
	"io"
	"os"
	"testing"

	scheduler "cloud.google.com/go/scheduler/apiv1beta1"
	"cloud.google.com/go/storage"
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

	// Open pipeline.json file and copy it to GCS
	body, _ := os.Open("pipeline.json")

	bucketName := os.Getenv("TF_VAR_gcp_bucket")
	objectName := os.Getenv("TF_VAR_object_name")

	storage_ctx := context.Background()
	storage_client, _ := storage.NewClient(storage_ctx)
	w := storage_client.Bucket(bucketName).Object(objectName).NewWriter(ctx)
	w.ContentType = "application/json"

	io.Copy(w, body)
	w.Close()

	// Delete the object from GCS after the test
	defer storage_client.Bucket(bucketName).Object(objectName).Delete(storage_ctx)

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
