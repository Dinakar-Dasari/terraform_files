output "aws_instance_ID" {
    value = aws_instance.module.id
}

output "aws_instance_private_ip" {
    value = aws_instance.module.private_ip
}

output "aws_instance_public_ip" {
    value = aws_instance.module.public_ip
}