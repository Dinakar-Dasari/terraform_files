module "vpc" {
  source              = "../../module/vpc_aws"
  tag                 = "roboshop"
  environment         = var.environment
  cidr_public         = var.cidr_public
  cidr_private        = var.cidr_private
  cidr_database       = var.cidr_database
  is_peering_required = false
}