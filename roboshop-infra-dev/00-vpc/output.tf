output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cidr_block" {
  value = module.vpc.cidr_block_public
}

output "cidr_block_private" {
  value = module.vpc.cidr_private
  }