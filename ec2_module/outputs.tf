output "private_ip" {
  value = module.ec2-instance.aws_instance_private_ip
}

output "public_ip" {
  value = module.ec2-instance.aws_instance_public_ip
}