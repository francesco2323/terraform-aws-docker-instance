Terraform module that provisions an AWS EC2 instance using the latest Amazon Linux 2023 AMI with Docker pre-installed.

This module is for demonstration purposes only and not intended for production use.

It serves as an example to illustrate how to create and publish a module on the Terraform Registry.

Usage:


provider "aws" {
  region = "us-east-1"
}

module "docker_instance" {
    source = "<github-username>/docker-instance/aws"
    key_name = "mykey"
}
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.tfmyec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.tf-sec-gr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.amazon-linux-2023](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_docker-instance-ports"></a> [docker-instance-ports](#input\_docker-instance-ports) | docker-instance-sec-gr-inbound-rules | `list(number)` | <pre>[<br/>  22,<br/>  80,<br/>  8080<br/>]</pre> | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"t2.micro"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | n/a | `string` | n/a | yes |
| <a name="input_num_of_instance"></a> [num\_of\_instance](#input\_num\_of\_instance) | n/a | `number` | `1` | no |
| <a name="input_server-name"></a> [server-name](#input\_server-name) | n/a | `string` | `"docker-instance"` | no |
| <a name="input_tag"></a> [tag](#input\_tag) | n/a | `string` | `"Docker-Instance"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | n/a |
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | n/a |
| <a name="output_sec_gr_id"></a> [sec\_gr\_id](#output\_sec\_gr\_id) | n/a |
<!-- END_TF_DOCS -->