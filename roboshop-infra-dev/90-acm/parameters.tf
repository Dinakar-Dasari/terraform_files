resource "aws_ssm_parameter" "acm_certificate_arn" {
  name        = "/${var.project}/${var.environment}/acm_certificate_arnm"
  description = "Stores the arn of the acm_certificate"
  type        = "String"
  value       = aws_acm_certificate.cert.arn
  tags = {
    Name = "${var.project}-acm_certificate_arn"
  }
}