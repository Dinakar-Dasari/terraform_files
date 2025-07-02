resource "aws_lb_target_group" "catalogue" {
  name     = "${var.project}-${var.environment}-catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc.value
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
    Name = "catalogue"
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
      "sudo sh /tmp/catalogue.sh catalogue"
    ]
  }
}