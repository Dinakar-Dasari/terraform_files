resource "aws_instance" "main" {
  ami                    = data.aws_ami.name.id
  instance_type          = "t2.micro"
  subnet_id              = local.public_subnet
  vpc_security_group_ids = [local.security_group]
  tags = {
    Name = "bastion"
  }
}