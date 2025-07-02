locals {
  public_subnet  = split("," , data.aws_ssm_parameter.cidr_public.value)[0]
  security_group = data.aws_ssm_parameter.sg_id.value
}       