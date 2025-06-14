resource "aws_instance" "terraform" {
  for_each               = var.instance_name #for_each
  ami                    = var.AMI_id
  instance_type          = each.value
  vpc_security_group_ids = [aws_security_group.security_terraform.id] ##using security group resource from line 10
  tags = {
  Name = each.key }
}

resource "aws_security_group" "security_terraform" {
  name        = "test"
  description = "Allow ALL terraform"
  dynamic "ingress" {
    for_each = var.ingress_block
    content {
      from_port        = ingress.value["from_port"]
      to_port          = ingress.value["to_port"]
      protocol         = "-1"
      cidr_blocks      = var.sg_cdr
      ipv6_cidr_blocks = var.sg_ipv6
    }
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