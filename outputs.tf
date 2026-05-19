output "instance_ids" {
  description = "IDs of created EC2 instances."
  value       = aws_instance.this[*].id
}

output "instance_public_ips" {
  description = "Public IPs of created EC2 instances."
  value       = aws_instance.this[*].public_ip
}

output "instance_private_ips" {
  description = "Private IPs of created EC2 instances."
  value       = aws_instance.this[*].private_ip
}

output "instance_arns" {
  description = "ARNs of created EC2 instances."
  value       = aws_instance.this[*].arn
}

output "security_group_id" {
  description = "Security group ID attached to instances."
  value       = local.security_group_ids[0]
}

output "ami_id" {
  description = "AMI ID used for EC2 instances."
  value       = data.aws_ami.amazon-linux-2023.id
}