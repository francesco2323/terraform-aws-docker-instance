terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "docker_instance" {
  source = "../../"

  key_name                    = var.key_name
  instance_type               = "t3.small"
  instance_count              = 1
  name                        = "docker-complete"
  server_name                 = "docker-complete-host"
  ingress_ports               = [22, 80, 443, 8080]
  create_security_group       = true
  associate_public_ip_address = false

  common_tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
    Service     = "docker"
  }
}
