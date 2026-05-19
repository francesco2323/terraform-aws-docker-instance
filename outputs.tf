output "instance_ids" {
  description = "IDs of created EC2 instances."
  value       = concat(aws_instance.with_created_security_group[*].id, aws_instance.with_existing_security_group[*].id)
}

output "instance_public_ips" {
  description = "Public IPs of created EC2 instances."
  value       = concat(aws_instance.with_created_security_group[*].public_ip, aws_instance.with_existing_security_group[*].public_ip)
}

output "instance_private_ips" {
  description = "Private IPs of created EC2 instances."
  value       = concat(aws_instance.with_created_security_group[*].private_ip, aws_instance.with_existing_security_group[*].private_ip)
}

output "instance_arns" {
  description = "ARNs of created EC2 instances."
  value       = concat(aws_instance.with_created_security_group[*].arn, aws_instance.with_existing_security_group[*].arn)
}

output "security_group_id" {
  description = "Security group ID attached to instances."
  value       = local.security_group_ids[0]
}

output "ami_id" {
  description = "AMI ID used for EC2 instances."
  value       = data.aws_ami.amazon-linux-2023.id
}
