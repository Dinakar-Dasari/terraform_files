## to login to private subnet using bastion host


resource "aws_instance" "private_ec2" {
  ami                    = data.aws_ami.name.id
  instance_type          = "t2.micro"
  subnet_id              = local.private_subnet
  vpc_security_group_ids = [local.private_sg_id]
  tags = {
    Name = "private_ec2"
  }
}

resource "aws_instance" "public_ec2" {
  ami                    = data.aws_ami.name.id
  instance_type          = "t2.micro"
  subnet_id              = local.public_subnet
  vpc_security_group_ids = [local.security_group]
  tags = {
    Name = "bastion"
  }
 
  connection {
    type             = "ssh"
    user             = "ec2-user"
    password         = "DevOps321"
    host             = aws_instance.private_ec2.private_ip
    bastion_host     = self.public_ip
    bastion_user     = "ec2-user"
    bastion_password = "DevOps321"
  }

  provisioner "remote-exec" {
    inline = ["sudo dnf install nginx -y",
      "sudo systemctl restart nginx",
    "nginx -version"]
  }
}