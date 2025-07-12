resource "aws_instance" "terraform" {
  ami           = "ami-09c813fb71547fc4f"
  instance_type = var.environment == "dev" ? "t3.micro" : "t2.small"
  vpc_security_group_ids = [ aws_security_group.security_terraform.id ]   ##using security group resource from line 10
  tags = { Name = "frontend" }
}

resource "aws_security_group" "security_terraform" {
  name        = "test"
  description = "Allow ALL terraform"
    ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    }
  tags = {
    Name = "terraform"
  } 
  
}