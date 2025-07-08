resource "aws_ssm_parameter" "backend_alb" {
  name        = "/${var.project}/${var.environment}/alb"
  description = "Stores the arn of the ALB"
  type        = "String"
  value       = aws_lb_listener.backend.arn
  tags = {
    Name = "${var.project}-alb"
  }
}