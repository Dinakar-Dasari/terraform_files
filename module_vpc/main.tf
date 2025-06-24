module "vpc" {
  source      = "../module/vpc_aws"
  tag         = var.tag
  environment = var.environment
  is_peering_required = false
}