locals {
  public_subnet  = split(",", data.aws_ssm_parameter.cidr_public.value)[0]
  security_group = data.aws_ssm_parameter.sg_id.value
  private_subnet = split(",", data.aws_ssm_parameter.cidr_private.value)[0]
  private_sg_id = data.aws_ssm_parameter.private_sg_id.value
}       