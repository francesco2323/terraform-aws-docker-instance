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


## Usage

```hcl
module "docker_instance" {
  source   = "francesco2323/docker-instance/aws"
  key_name = "my-keypair"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to associate a public IP address with the instance network interface. | `bool` | `false` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags applied to all resources created by this module. | `map(string)` | `{}` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Whether this module should create a security group. | `bool` | `true` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | Whether to launch instances as EBS-optimized. | `bool` | `true` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | Outbound security group rules applied when create\_security\_group is true. | <pre>list(object({<br/>    description = string<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = list(string)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ],<br/>    "description": "Allow outbound HTTPS",<br/>    "from_port": 443,<br/>    "protocol": "tcp",<br/>    "to_port": 443<br/>  },<br/>  {<br/>    "cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ],<br/>    "description": "Allow outbound DNS (TCP)",<br/>    "from_port": 53,<br/>    "protocol": "tcp",<br/>    "to_port": 53<br/>  },<br/>  {<br/>    "cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ],<br/>    "description": "Allow outbound DNS (UDP)",<br/>    "from_port": 53,<br/>    "protocol": "udp",<br/>    "to_port": 53<br/>  }<br/>]</pre> | no |
| <a name="input_enable_detailed_monitoring"></a> [enable\_detailed\_monitoring](#input\_enable\_detailed\_monitoring) | Whether to enable detailed monitoring on the EC2 instances. | `bool` | `true` | no |
| <a name="input_iam_instance_profile_name"></a> [iam\_instance\_profile\_name](#input\_iam\_instance\_profile\_name) | IAM instance profile name to attach to the EC2 instances. Set to null to skip attachment. | `string` | `null` | no |
| <a name="input_ingress_ports"></a> [ingress\_ports](#input\_ingress\_ports) | Ingress TCP ports allowed to the instance security group. | `list(number)` | <pre>[<br/>  22,<br/>  80,<br/>  8080<br/>]</pre> | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of EC2 instances to create. | `number` | `1` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type. | `string` | `"t3.micro"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | EC2 key pair name used for SSH access. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Base name applied to resources and Name tag. | `string` | `"docker-instance"` | no |
| <a name="input_root_volume_type"></a> [root\_volume\_type](#input\_root\_volume\_type) | Root EBS volume type for instances. | `string` | `"gp3"` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | Existing security group ID to use when create\_security\_group is false. | `string` | `null` | no |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | Hostname configured by userdata. | `string` | `"docker-instance"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Optional subnet ID for EC2 instances. | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for the created security group. If null, default VPC is used. | `string` | `null` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ami_id"></a> [ami\_id](#output\_ami\_id) | AMI ID used for EC2 instances. |
| <a name="output_instance_arns"></a> [instance\_arns](#output\_instance\_arns) | ARNs of created EC2 instances. |
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | IDs of created EC2 instances. |
| <a name="output_instance_private_ips"></a> [instance\_private\_ips](#output\_instance\_private\_ips) | Private IPs of created EC2 instances. |
| <a name="output_instance_public_ips"></a> [instance\_public\_ips](#output\_instance\_public\_ips) | Public IPs of created EC2 instances. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security group ID attached to instances. |
## Resources

| Name | Type |
|------|------|
| [aws_instance.with_created_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.with_existing_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |
<!-- END_TF_DOCS -->
