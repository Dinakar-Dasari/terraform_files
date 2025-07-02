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

data "aws_ssm_parameter" "mongodb_sg" {
  name = "/${var.project}/${var.environment}/mongodb"
}

data "aws_ssm_parameter" "redis_sg" {
  name = "/${var.project}/${var.environment}/redis_db"
}

data "aws_ssm_parameter" "mysql" {
  name = "/${var.project}/${var.environment}/mysqldb"
}

data "aws_ssm_parameter" "rabbitmq" {
  name = "/${var.project}/${var.environment}/rabbitmq"
}


data "aws_ssm_parameter" "cidr_database" {
  name = "/${var.project}/${var.environment}/cidr_database"
}