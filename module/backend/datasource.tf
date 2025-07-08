data "aws_ssm_parameter" "vpc" {
  name = "/${var.project}/${var.environment}/vpc"
}

data "aws_ssm_parameter" "cidr_private" {
  name = "/${var.project}/${var.environment}/cidr_private"
}

data "aws_ssm_parameter" "backend_alb_sg" {
  name = "/${var.project}/backend_alb_sg"
}


data "aws_ssm_parameter" "sg_id" {
  name = "/${var.project}/${var.environment}/${var.component}"
}


data "aws_ami" "name" {

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "vpn_sg_id" {
  name = "/${var.project}/roboshop_vpn"
}

data "aws_ssm_parameter" "alb_arn" {
  name = "/${var.project}/${var.environment}/alb"
}

data "aws_ssm_parameter" "frontend_alb" {
  name = "/${var.project}/${var.environment}/frontend_alb"
}