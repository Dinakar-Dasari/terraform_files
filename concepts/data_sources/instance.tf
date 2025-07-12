resource "aws_instance" "terraform" {
  ami           = data.aws_ami.name.id
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.security_terraform.id ]   ##using security group resource from line 10
  tags = var.tags
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