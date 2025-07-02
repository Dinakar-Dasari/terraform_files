data "aws_ssm_parameter" "vpc" {
  name = "/${var.project}/${var.environment}/vpc"
}

# data "aws_ssm_parameter" "bastion_sg_id" {
#   name = "/${var.project}/${var.environment}/${var.bastion_name}_sg_id"
# }
##not required as i am in same folder can use module.bastion.sg_id
