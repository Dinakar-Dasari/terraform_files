resource "aws_instance" "terraform" {
  count                  = length(var.instances)
  ami                    = var.AMI_id
  instance_type          = var.instance_type[terraform.workspace]  
  ###also write as instance_type = lookup(var.instance_type, terraform.workspace)
  vpc_security_group_ids = [aws_security_group.security_terraform.id] ##using security group resource from line 10
  tags = {
    Name = "${var.project}-${var.instances[count.index]}-${terraform.workspace}"
  }
}

resource "aws_security_group" "security_terraform" {
  name        = "${var.project}-${var.security}-${terraform.workspace}"
  description = "Allow ALL terraform"
  ingress {
    from_port        = var.from_port
    to_port          = var.to_port
    protocol         = "-1"
    cidr_blocks      = var.sg_cdr
    ipv6_cidr_blocks = var.sg_ipv6
  }
  egress {
    from_port        = var.from_port
    to_port          = var.to_port
    protocol         = "-1"
    cidr_blocks      = var.sg_cdr
    ipv6_cidr_blocks = var.sg_ipv6
  }
  tags = {
    Name = "terraform"
  }

}