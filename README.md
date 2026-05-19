# terraform-aws-docker-instance

Production-ready Terraform module that provisions Docker-enabled EC2 instances on Amazon Linux 2023.

## What This Module Does

- SRE-first defaults with input validation and composability
- Optional create-vs-existing security group pattern
- Standardized tagging with common_tags
- CI-ready workflows for validate, security, testing, and release

## Repository Layout

```text
terraform-aws-docker-instance/
├── .github/
│   ├── CODEOWNERS
│   └── workflows/
│       ├── conventional-commits.yml
│       ├── dast.yml
│       ├── docs.yml
│       ├── release.yml
│       ├── renovate.yml
│       ├── sast.yml
│       ├── security.yml
│       ├── test.yml
│       └── validate.yml
├── examples/
│   ├── basic/
│   └── complete/
├── test/
│   ├── go.mod
│   ├── go.sum
│   └── module_test.go
├── .commitlintrc.cjs
├── .pre-commit-config.yaml
├── .terraform-docs.yml
├── .terraform-registry.yml
├── .tflint.hcl
├── CHANGELOG.md
├── README.md
├── README_HEADER.md
├── main.tf
├── outputs.tf
├── renovate.json
├── userdata.sh
├── variables.tf
└── versions.tf
```

### Core Terraform module files

- `main.tf`: defines the AWS resources and data sources used by the module, including the EC2 instance, AMI lookup, security group logic, and local values.
- `variables.tf`: declares all module inputs, defaults, and validation rules. Start here when you want to understand what consumers can configure.
- `outputs.tf`: exposes the values returned by the module, such as instance IDs, IP addresses, ARNs, and security group ID.
- `versions.tf`: pins the supported Terraform and provider versions.
- `userdata.sh`: bootstrap script passed to the EC2 instance to install and enable Docker.

### Documentation and registry metadata

- `README.md`: primary module documentation for GitHub and the Terraform Registry.
- `README_HEADER.md`: source content for the human-written top section of the README. Update this file when you want permanent narrative documentation that survives terraform-docs regeneration.
- `.terraform-docs.yml`: controls how terraform-docs rebuilds the generated sections in the README.
- `.terraform-registry.yml`: metadata used for Terraform Registry presentation.
- `CHANGELOG.md`: release history maintained by the release workflow.

### Examples and tests

- `examples/basic/`: minimal example showing the smallest working module usage.
- `examples/complete/`: more complete example with tags and custom port settings.
- `test/module_test.go`: Terratest integration test for the complete example.
- `test/go.mod`: Go module definition for Terratest dependencies.
- `test/go.sum`: locked dependency checksums for reproducible Go test runs.

### Local quality gates

- `.pre-commit-config.yaml`: local developer checks run before commit, including formatting, docs generation, TFLint, tfsec, and Checkov.
- `.tflint.hcl`: TFLint configuration and AWS ruleset setup.
- `.commitlintrc.cjs`: Conventional Commit rules for commit message validation.

### GitHub automation

- `.github/workflows/validate.yml`: runs terraform fmt, init, validate, and TFLint.
- `.github/workflows/docs.yml`: verifies README stays in sync with terraform-docs output.
- `.github/workflows/security.yml`: DevSecOps matrix pipeline running TFLint, Trivy, and Checkov, then publishing a summarized PR report.
- `.github/workflows/test.yml`: runs Terratest.
- `.github/workflows/sast.yml`: runs CodeQL for static application security testing.
- `.github/workflows/dast.yml`: optional manual OWASP ZAP baseline scan against a target URL.
- `.github/workflows/conventional-commits.yml`: validates commit messages and PR titles.
- `.github/workflows/release.yml`: runs semantic-release on the main branch.
- `.github/workflows/renovate.yml`: validates the Renovate configuration.
- `.github/CODEOWNERS`: defines the default reviewers/owners for repository paths.
- `renovate.json`: configures automated dependency update pull requests.

## How To Use This Repository

### As a Terraform module consumer

Use the module from the Terraform Registry or GitHub source and configure the inputs documented below. The simplest starting point is the basic example.

### As a module maintainer

- Edit Terraform behavior in `main.tf`, `variables.tf`, `outputs.tf`, and `userdata.sh`.
- Update narrative docs in `README_HEADER.md`.
- Regenerate or verify docs through terraform-docs or the docs workflow.
- Validate changes locally with pre-commit, Terraform validation, and Terratest.

## Maintainer Checklist

### Before opening or merging a pull request

- Run `pre-commit run --all-files`.
- Run `terraform fmt -check -recursive` and `terraform validate`.
- Run `go test -v ./...` in `test/` when the change affects examples, outputs, or runtime behavior.
- Confirm `README.md` is in sync with `README_HEADER.md` and terraform-docs generated sections.
- Review security workflow results for TFLint, Trivy, and Checkov findings.

### Before publishing publicly or cutting a release

- Verify no credentials, private keys, or environment-specific values are committed.
- Confirm examples still work and reflect the current recommended usage.
- Check `CODEOWNERS`, Renovate, and workflow files for the intended repository owner or team names.
- Ensure commits and PR title follow Conventional Commits so semantic-release can version correctly.
- Confirm `CHANGELOG.md` and release automation are ready for the next tag.
- Push only after CI is green on validate, security, test, docs, and SAST workflows.

### As a CI/CD operator

Review the workflows under `.github/workflows/` to understand which checks run on pull requests, pushes, and manual triggers. Security findings are summarized automatically on pull requests.

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
