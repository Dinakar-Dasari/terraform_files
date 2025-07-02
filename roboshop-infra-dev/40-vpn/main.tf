resource "aws_instance" "vpn" {
  ami                    = "ami-015bde79b8dffa19b"
  instance_type          = "t2.micro"
  subnet_id              = local.public_subnet
  vpc_security_group_ids = [local.security_group]
  user_data              = file("openvpn.sh")
  key_name               = "roboshop"
  tags = {
    Name = "vpn"
  }
}