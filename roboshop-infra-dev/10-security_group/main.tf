module "sg_frontend" {
  source      = "../../module/security_group"
  description = "Creating security group for fronted dev"
  vpc_id = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = var.client
  sg_name     = var.security_name
}