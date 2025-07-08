data "aws_ssm_parameter" "vpc" {
  name = "/${var.project}/${var.environment}/vpc"
}

data "aws_ssm_parameter" "cidr_private" {
  name = "/${var.project}/${var.environment}/cidr_private"
}

data "aws_ssm_parameter" "frontend_alb_sg_id" {
  name = "/${var.project}/${var.environment}/frontend_alb_sg"
}

data "aws_ssm_parameter" "cidr_public" {
  name = "/${var.project}/${var.environment}/cidr_public"
}

data "aws_ssm_parameter" "certificate_arn" {
  name        = "/${var.project}/${var.environment}/acm_certificate_arnm"
}


