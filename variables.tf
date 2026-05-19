variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name used for SSH access."

  validation {
    condition     = length(trimspace(var.key_name)) > 0
    error_message = "key_name must be a non-empty string."
  }
}

variable "instance_count" {
  type        = number
  description = "Number of EC2 instances to create."
  default     = 1

  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10
    error_message = "instance_count must be between 1 and 10."
  }
}

variable "name" {
  type        = string
  description = "Base name applied to resources and Name tag."
  default     = "docker-instance"
}

variable "server_name" {
  type        = string
  description = "Hostname configured by userdata."
  default     = "docker-instance"
}

variable "ingress_ports" {
  type        = list(number)
  description = "Ingress TCP ports allowed to the instance security group."
  default     = [22, 80, 8080]

  validation {
    condition     = alltrue([for p in var.ingress_ports : p >= 1 && p <= 65535])
    error_message = "All ingress ports must be between 1 and 65535."
  }
}

variable "create_security_group" {
  type        = bool
  description = "Whether this module should create a security group."
  default     = true
}

variable "security_group_id" {
  type        = string
  description = "Existing security group ID to use when create_security_group is false."
  default     = null

  validation {
    condition     = var.create_security_group || length(try(trimspace(var.security_group_id), "")) > 0
    error_message = "security_group_id must be set when create_security_group is false."
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the created security group. If null, default VPC is used."
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "Optional subnet ID for EC2 instances."
  default     = null
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Whether to associate a public IP address with the instance network interface."
  default     = false
}

variable "iam_instance_profile_name" {
  type        = string
  description = "IAM instance profile name to attach to the EC2 instances. Set to null to skip attachment."
  default     = null
}

variable "ebs_optimized" {
  type        = bool
  description = "Whether to launch instances as EBS-optimized."
  default     = true
}

variable "enable_detailed_monitoring" {
  type        = bool
  description = "Whether to enable detailed monitoring on the EC2 instances."
  default     = true
}

variable "root_volume_type" {
  type        = string
  description = "Root EBS volume type for instances."
  default     = "gp3"
}

variable "egress_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Outbound security group rules applied when create_security_group is true."
  default = [
    {
      description = "Allow outbound HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow outbound DNS (TCP)"
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow outbound DNS (UDP)"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all resources created by this module."
  default     = {}
}
