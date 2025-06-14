resource "aws_instance" "terraform" {
  ami                    = var.AMI_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.security_terraform.id] ##using security group resource from line 10
  tags                   = var.tags

  provisioner "local-exec" {
    #this is during creation. BY default it's creation
    command = "echo 'creating instances in the AWS'"
  }

  provisioner "local-exec" {
    #this should throw error and quit the script ideally but since we are using on_failure = continue it will no exit
    command    = self.public_ip
    #on_failure = continue
  }

  provisioner "local-exec" {
    # this is during destroying
    when    = destroy
    command = "echo 'destroying the instance'"
  }

}

resource "aws_security_group" "security_terraform" {
  name        = "test"
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