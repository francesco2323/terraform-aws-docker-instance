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