# terraform-aws-docker-instance

Production-ready Terraform module that provisions Docker-enabled EC2 instances on Amazon Linux 2023.

## Features

- SRE-first defaults with input validation and composability
- Optional create-vs-existing security group pattern
- Standardized tagging with common_tags
- CI-ready workflows for validate, security, testing, and release

## Usage

```hcl
provider "aws" {
  region = "us-east-1"
}

module "docker_instance" {
  source = "francesco2323/docker-instance/aws"

  key_name = "my-keypair"
  common_tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

## Examples

- examples/basic: minimum viable usage
- examples/complete: full-featured usage with tags and custom ports

<!-- BEGIN_TF_DOCS -->
## Requirements

- terraform: >= 1.5.0
- aws: ~> 6.0

## Providers

- aws: ~> 6.0

## Resources

| Name | Type |
| ---- | ---- |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.amazon-linux-2023](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| associate_public_ip_address | Whether to associate a public IP address with the instance network interface. | `bool` | `true` | no |
| common_tags | Common tags applied to all resources created by this module. | `map(string)` | `{}` | no |
| create_security_group | Whether this module should create a security group. | `bool` | `true` | no |
| ingress_ports | Ingress TCP ports allowed to the instance security group. | `list(number)` | `[22, 80, 8080]` | no |
| instance_count | Number of EC2 instances to create. | `number` | `1` | no |
| instance_type | EC2 instance type. | `string` | `"t3.micro"` | no |
| key_name | EC2 key pair name used for SSH access. | `string` | n/a | yes |
| name | Base name applied to resources and Name tag. | `string` | `"docker-instance"` | no |
| security_group_id | Existing security group ID to use when create_security_group is false. | `string` | `null` | no |
| server_name | Hostname configured by userdata. | `string` | `"docker-instance"` | no |
| subnet_id | Optional subnet ID for EC2 instances. | `string` | `null` | no |
| vpc_id | VPC ID for the created security group. If null, default VPC is used. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| ami_id | AMI ID used for EC2 instances. |
| instance_arns | ARNs of created EC2 instances. |
| instance_ids | IDs of created EC2 instances. |
| instance_private_ips | Private IPs of created EC2 instances. |
| instance_public_ips | Public IPs of created EC2 instances. |
| security_group_id | Security group ID attached to instances. |
<!-- END_TF_DOCS -->