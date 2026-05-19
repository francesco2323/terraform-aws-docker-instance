output "instance_public_ips" {
  value = module.docker_instance.instance_public_ips
}

output "instance_ids" {
  value = module.docker_instance.instance_ids
}

output "security_group_id" {
  value = module.docker_instance.security_group_id
}

output "instance_arns" {
  value = module.docker_instance.instance_arns
}
