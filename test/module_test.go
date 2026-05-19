package test

import (
  "os"
  "testing"

  "github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/stretchr/testify/assert"
)

func TestModuleComplete(t *testing.T) {
  t.Parallel()

  keyName := os.Getenv("TEST_KEY_NAME")
  if keyName == "" {
    t.Skip("TEST_KEY_NAME is not set; skipping integration test")
  }

  region := os.Getenv("AWS_REGION")
  if region == "" {
    region = "us-east-1"
  }

  terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
    TerraformDir: "../examples/complete",
    Vars: map[string]interface{}{
      "aws_region": region,
      "key_name":   keyName,
    },
    NoColor: true,
  })

  defer terraform.Destroy(t, terraformOptions)
  terraform.InitAndApply(t, terraformOptions)

  instanceIDs := terraform.OutputList(t, terraformOptions, "instance_ids")
  sgID := terraform.Output(t, terraformOptions, "security_group_id")

  assert.NotEmpty(t, instanceIDs)
  assert.NotEmpty(t, sgID)
}
