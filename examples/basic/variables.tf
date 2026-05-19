variable "aws_region" {
  type        = string
  description = "AWS region for this example."
  default     = "us-east-1"
}

variable "key_name" {
  type        = string
  description = "Existing EC2 key pair name."
}
