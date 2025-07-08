resource "aws_ssm_parameter" "frontend_alb" {
  name        = "/${var.project}/${var.environment}/frontend_alb"
  description = "Stores the arn of the frontend ALB"
  type        = "String"
  overwrite =    true
  value       = aws_lb_listener.frontend_alb.arn
  tags = {
    Name = "${var.project}-frontend_alb"
  }
}