module "alb" {
  source                = "terraform-aws-modules/alb/aws"
  name                  = "backend-alb"
  vpc_id                = data.aws_ssm_parameter.vpc.value
  subnets               = split(",",data.aws_ssm_parameter.cidr_private.value) ##WE NEED alteast 2 subnets so not using [0] compared to other reosurces like bastion
  create_security_group = false
  security_groups       = [data.aws_ssm_parameter.backend_alb_sg_id.value]
  internal              = true
  enable_deletion_protection = false  
}


### no target group is attached. So for testing purpose
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = module.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "<h1> Hello testing the load balancer </h1>"
      status_code  = "200"
    }
  }
}


####people cannot search with DNS name so create a subdomain
resource "aws_route53_record" "backend_alb" {
  zone_id = var.aws_zone_id
  name    = "*.backend.${var.aws_zone_name}"
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}