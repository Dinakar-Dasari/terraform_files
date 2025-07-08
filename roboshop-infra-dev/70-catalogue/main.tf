resource "aws_lb_target_group" "catalogue" {
  name                 = "${var.project}-${var.environment}-catalogue"
  #When I send traffic to this EC2 instance, which port should I use?”
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = data.aws_ssm_parameter.vpc.value
  deregistration_delay = 120
  health_check {
    enabled             = true
    healthy_threshold   = 2
    matcher             = "200-299"
    path                = "/health"
    interval            = 5
    port                = 8080
    unhealthy_threshold = 3
    timeout             = 3
  }
}


#Browser → ALB (port 80) → Target Group → EC2 (port 8080)

resource "aws_instance" "catalogue" {
  ami                    = data.aws_ami.name.id
  instance_type          = "t2.micro"
  subnet_id              = local.private_subnet
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  tags = {
    Name = "catalogue-${var.environment}"
  }
}

resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]
  #  file provisioner is used when you need to transfer content from the machine where Terraform is running (your local machine or CI/CD runner) to a newly created remote resource (like an EC2 instance, a virtual machine, etc.).

  provisioner "file" {
    source      = "catalogue.sh"
    destination = "/tmp/catalogue.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.catalogue.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/catalogue.sh",
      "sudo sh /tmp/catalogue.sh catalogue ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on  = [terraform_data.catalogue]
}

resource "aws_ami_from_instance" "catalogue" {
  name               = "${var.project}-${var.environment}-catalogue"
  source_instance_id = aws_instance.catalogue.id
  depends_on         = [aws_ec2_instance_state.catalogue]
  tags = {
    Name = "${var.project}-${var.environment}-catalogue"
  }
}

resource "terraform_data" "destroy_ec2" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"
  }
  depends_on = [aws_ami_from_instance.catalogue]

}

resource "aws_launch_template" "catalogue" {
  name                                 = "${var.project}-${var.environment}-catalogue"
  image_id                             = aws_ami_from_instance.catalogue.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project}-${var.environment}-catalogue"
    }
  }
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  # when we made any changes to the template then the changes won't reflect while creating the instance if we select as the default version. SO we are telling that when you template take latest version as the default template
  update_default_version = true # each time you update, new version will become default
}

resource "aws_autoscaling_group" "catalogue" {
  name                      = "${var.project}-${var.environment}-catalogue"
  vpc_zone_identifier       = local.private_subnetids
  target_group_arns         = [aws_lb_target_group.catalogue.arn]
  desired_capacity          = 1
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 180
  health_check_type         = "ELB"
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }
  timeouts {
    delete = "15m"
  }
}

resource "aws_autoscaling_policy" "catalogue" {
  name                      = "${var.project}-${var.environment}-catalogue"
  estimated_instance_warmup = 180
  autoscaling_group_name    = aws_autoscaling_group.catalogue.name
  policy_type               = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60.0
  }

}

resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = data.aws_ssm_parameter.alb_arn.value
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.backend-${var.environment}.${var.aws_zone_name}"]
    }
  }
}

