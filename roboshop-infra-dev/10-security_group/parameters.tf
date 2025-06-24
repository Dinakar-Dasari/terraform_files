resource "aws_ssm_parameter" "sg_id" {
  name        = "/${var.project}/${var.environment}/${var.client}_sg_id"
  description = "Stores the security group id for frontend"
  type        = "String"
  value       = module.sg_frontend.sg_id
  tags = {
    Name = "${var.project}-${var.environment}-sg-id"
}
}