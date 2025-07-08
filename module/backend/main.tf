resource "aws_lb_target_group" "main" {
  name                 = "${var.project}-${var.environment}-${var.component}"
  port                 = local.port
  protocol             = "HTTP"
  vpc_id               = data.aws_ssm_parameter.vpc.value
  deregistration_delay = 120
  health_check {
    enabled             = true
    healthy_threshold   = 2
    matcher             = "200-299"
    path                = local.health_path
    interval            = 5
    port                = local.port
    unhealthy_threshold = 3
    timeout             = 3
  }
}


#Browser → ALB (port 80) → Target Group → EC2 (port 8080)

resource "aws_instance" "main" {
  ami                    = data.aws_ami.name.id
  instance_type          = "t2.micro"
  subnet_id              = local.private_subnet   #launching frontend instance also in private subnet
  vpc_security_group_ids = [data.aws_ssm_parameter.sg_id.value]
  tags = {
    Name = "${var.component}-${var.environment}"
  }
}

resource "terraform_data" "main" {
  triggers_replace = [
    aws_instance.main.id
  ]
  #  file provisioner is used when you need to transfer content from the machine where Terraform is running (your local machine or CI/CD runner) to a newly created remote resource (like an EC2 instance, a virtual machine, etc.).

  provisioner "file" {
    source      = "bootstraph.sh"
    destination = "/tmp/${var.component}.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.main.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.component}.sh",
      "sudo sh /tmp/${var.component}.sh ${var.component} ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "main" {
  instance_id = aws_instance.main.id
  state       = "stopped"
  depends_on  = [terraform_data.main]
}

resource "aws_ami_from_instance" "main" {
  name               = "${var.project}-${var.environment}-${var.component}"
  source_instance_id = aws_instance.main.id
  depends_on         = [aws_ec2_instance_state.main]
  tags = {
    Name = "${var.project}-${var.environment}-${var.component}"
  }
}

resource "terraform_data" "destroy_ec2" {
  triggers_replace = [
    aws_instance.main.id
  ]

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.main.id}"
  }
  depends_on = [aws_ami_from_instance.main]

}

resource "aws_launch_template" "main" {
  name                                 = "${var.project}-${var.environment}-${var.component}"
  image_id                             = aws_ami_from_instance.main.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project}-${var.environment}-${var.component}"
    }
  }
  vpc_security_group_ids = [data.aws_ssm_parameter.sg_id.value]
  # when we made any changes to the template then the changes won't reflect while creating the instance if we select as the default version. SO we are telling that when you template take latest version as the default template
  update_default_version = true # each time you update, new version will become default
}

resource "aws_autoscaling_group" "main" {
  name                      = "${var.project}-${var.environment}-${var.component}"
  vpc_zone_identifier       = local.private_subnetids
  target_group_arns         = [aws_lb_target_group.main.arn]
  desired_capacity          = 1
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 180
  health_check_type         = "ELB"
  launch_template {
    id      = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
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


# when to launch new instances is basaed on cpu load
resource "aws_autoscaling_policy" "main" {
  name                      = "${var.project}-${var.environment}-${var.component}"
  estimated_instance_warmup = 180
  autoscaling_group_name    = aws_autoscaling_group.main.name
  policy_type               = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60.0
  }

}

resource "aws_lb_listener_rule" "main" {
  listener_arn = local.listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    host_header {
      values = [local.host_header]
    }
  }
}

