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

data "aws_ssm_parameter" "cidr_public" {
  name = "/${var.project}/${var.environment}/cidr_public"
}