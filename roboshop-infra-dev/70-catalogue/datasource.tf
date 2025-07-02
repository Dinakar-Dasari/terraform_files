data "aws_ssm_parameter" "vpc" {
  name = "/${var.project}/${var.environment}/vpc"
}

data "aws_ssm_parameter" "cidr_private" {
  name = "/${var.project}/${var.environment}/cidr_private"
}

data "aws_ssm_parameter" "backend_alb_sg_id" {
  name = "/${var.project}/backend_alb"
}


data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project}/${var.environment}/catalogue"
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
