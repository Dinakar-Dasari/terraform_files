resource "aws_ssm_parameter" "vpc_id" {
  name        = "/${var.tag}/${var.environment["Name"]}/vpc"
  description = "Stores the VPC id"
  type        = "String"
  value       = module.vpc.vpc_id
  tags = {
    Name = "${var.tag}-${var.environment["Name"]}-vpc"
  }
}

resource "aws_ssm_parameter" "cidr_public" {
  name        = "/${var.tag}/${var.environment["Name"]}/cidr_public"
  description = "Stores the cidr_public"
  type        = "StringList"
  value       = join("," , module.vpc.cidr_block_public)
  tags = {
    Name = "${var.tag}-${var.environment["Name"]}-cidr_public"
  }
}

resource "aws_ssm_parameter" "cidr_private" {
  name        = "/${var.tag}/${var.environment["Name"]}/cidr_private"
  description = "Stores the cidr_private"
  type        = "StringList"
  value       = join("," , module.vpc.cidr_private)
  tags = {
    Name = "${var.tag}-${var.environment["Name"]}-cidr_private"
  }
}

resource "aws_ssm_parameter" "cidr_database" {
  name        = "/${var.tag}/${var.environment["Name"]}/cidr_database"
  description = "Stores the cidr_database"
  type        = "StringList"
  value       = join("," , module.vpc.cidr_database)
  tags = {
    Name = "${var.tag}-${var.environment["Name"]}-cidr_database"
  }
}