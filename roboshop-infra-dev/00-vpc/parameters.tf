resource "aws_ssm_parameter" "vpc_id" {
  name        = "/${var.tag}/${var.environment["Name"]}/vpc"
  description = "Stores the VPC id"
  type        = "String"
  value       = module.vpc.vpc_id
  tags = {
    Name = "${var.tag}-${var.environment["Name"]}-vpc"
  }
}