package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformWebserverExample (t *testing.T) {
	
	// The values to pass into the Terraform CLI
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		// The Path to where the example Terraform code is
		TerraformDir: "..\\examples\\webserver",

		// Variables to pass to the Terraform code using -var options
		Vars: map[string]interface{}{
			"region": "eu-west-2",
			"servername": "testwebserver",
		},
		
	})

	// Run a Terraform init and apply with the Terraform options
	terraform.InitAndApply(t, terraformOptions)

	// Run a Terraform destroy at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	publicIP := terraform.Output(t, terraformOptions, "public_ip")

	url := fmt.Sprintf("http://%s:8080", publicIP)

	http_helper.HttpGetWithRetry(t, url, nil, 200, "I created a Terraform module!", 30, 5*time.Second)

}