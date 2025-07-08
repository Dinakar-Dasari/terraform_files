module "frontend_alb" {
  source                     = "terraform-aws-modules/alb/aws"
  name                       = "frontend-alb-dev"
  vpc_id                     = data.aws_ssm_parameter.vpc.value
  subnets                    = split(",", data.aws_ssm_parameter.cidr_public.value) ##WE NEED alteast 2 subnets so not using [0] compared to other reosurces like bastion
  create_security_group      = false
  security_groups            = [data.aws_ssm_parameter.frontend_alb_sg_id.value]
  internal                   = false
  enable_deletion_protection = false
}


### no target group is attached. So for testing purpose
resource "aws_lb_listener" "frontend_alb" {
  load_balancer_arn = module.frontend_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_ssm_parameter.certificate_arn.value
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "<h1> Hello testing the frontend load balancer </h1>"
      status_code  = "200"
    }
  }
}


####  people cannot search with DNS name so create a subdomain
resource "aws_route53_record" "frontend_alb" {
  zone_id = var.aws_zone_id
  name    = "dev.${var.aws_zone_name}"
  type    = "A"

  alias {
    name                   = module.frontend_alb.dns_name
    zone_id                = module.frontend_alb.zone_id
    evaluate_target_health = true
  }
}