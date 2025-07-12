resource "aws_instance" "dev" {
  ami           = "ami-09c813fb71547fc4f"
  instance_type = "t2.micro"
  tags = {
    Name = "instance_practice"
  }
  vpc_security_group_ids = [aws_security_group.security.id]
  provider = aws.dev   ## this will tell on which aws account this resource needs to be created
}


resource "aws_instance" "prod" {
  ami           = "ami-09c813fb71547fc4f"
  instance_type = "t2.micro"
  tags = {
    Name = "instance_practice"
  }
  vpc_security_group_ids = [aws_security_group.security.id]
  provider = aws.prod
}



resource "aws_security_group" "security" {
  # ... other configuration ...

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}