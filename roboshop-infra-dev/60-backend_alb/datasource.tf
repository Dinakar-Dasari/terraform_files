data "aws_ssm_parameter" "vpc" {
  name = "/${var.project}/${var.environment}/vpc"
}

data "aws_ssm_parameter" "cidr_private" {
  name = "/${var.project}/${var.environment}/cidr_private"
}

data "aws_ssm_parameter" "backend_alb_sg_id" {
  name = "/${var.project}/backend_alb"
}