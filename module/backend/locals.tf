locals {
  # public_subnet  = split(",", data.aws_ssm_parameter.cidr_public.value)[0]
  security_group    = data.aws_ssm_parameter.sg_id.value
  private_subnet    = split(",", data.aws_ssm_parameter.cidr_private.value)[0]
  private_subnetids = split(",", data.aws_ssm_parameter.cidr_private.value)
  backend_listener = data.aws_ssm_parameter.alb_arn.value
  frontend_listener = data.aws_ssm_parameter.frontend_alb.value
  vpc_id = data.aws_ssm_parameter.vpc.value
  port = "${var.component}" == "frontend" ? 80 : 8080 
  health_path =  "${var.component}" == "frontend" ? "/" : "/health" 
  listener_arn = "${var.component}" == "frontend" ? local.frontend_listener : local.backend_listener
  host_header = "${var.component}" == "frontend" ? "${var.environment}.${var.aws_zone_name}" : "${var.component}.backend-${var.environment}.${var.aws_zone_name}" 
}       