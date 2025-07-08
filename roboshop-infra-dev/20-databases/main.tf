resource "aws_instance" "mongodb" {
  ami                    = data.aws_ami.name.id
  instance_type          = "t2.micro"
  subnet_id              = local.database_subnet
  vpc_security_group_ids = [local.mongo_db]
  tags = {
    Name = "mongodb-${var.environment}"
  }
}

resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id
  ]
  #  file provisioner is used when you need to transfer content from the machine where Terraform is running (your local machine or CI/CD runner) to a newly created remote resource (like an EC2 instance, a virtual machine, etc.).

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb"
    ]
  }
}

resource "aws_instance" "redis" {
  ami                    = data.aws_ami.name.id
  instance_type          = "t2.micro"
  subnet_id              = local.database_subnet
  vpc_security_group_ids = [local.redis]
  tags = {
    Name = "redis-${var.environment}"
  }
}

resource "terraform_data" "redis" {
  triggers_replace = [
    aws_instance.redis.id
  ]
  #  file provisioner is used when you need to transfer content from the machine where Terraform is running (your local machine or CI/CD runner) to a newly created remote resource (like an EC2 instance, a virtual machine, etc.).

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.redis.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis"
    ]
  }
}


resource "aws_instance" "mysql" {
  ami                    = data.aws_ami.name.id
  instance_type          = "t2.micro"
  subnet_id              = local.database_subnet
  vpc_security_group_ids = [local.mysql]
  iam_instance_profile = "IAMroletofetchSSMparameter"  #to access SSM parameter need to access AWS
  tags = {
    Name = "mysql-${var.environment}"
  }
}

resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql.id
  ]
  #  file provisioner is used when you need to transfer content from the machine where Terraform is running (your local machine or CI/CD runner) to a newly created remote resource (like an EC2 instance, a virtual machine, etc.).

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mysql.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql"
    ]
  }
}

resource "aws_instance" "rabbitmq" {
  ami                    = data.aws_ami.name.id
  instance_type          = "t2.micro"
  subnet_id              = local.database_subnet
  vpc_security_group_ids = [local.rabbitmq]
  tags = {
    Name = "rabbitmq-${var.environment}"
  }
}

resource "terraform_data" "rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq.id
  ]
  #  file provisioner is used when you need to transfer content from the machine where Terraform is running (your local machine or CI/CD runner) to a newly created remote resource (like an EC2 instance, a virtual machine, etc.).

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.rabbitmq.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq"
    ]
  }
}

resource "aws_route53_record" "mongodb" {
  zone_id = var.aws_zone_id
  name    = "mongodb-${var.environment}.${var.aws_zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
}

resource "aws_route53_record" "redis" {
  zone_id = var.aws_zone_id
  name    = "redis-${var.environment}.${var.aws_zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
}

resource "aws_route53_record" "mysql" {
  zone_id = var.aws_zone_id
  name    = "mysql-${var.environment}.${var.aws_zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
}

resource "aws_route53_record" "rabbitmq" {
  zone_id = var.aws_zone_id
  name    = "rabbitmq-${var.environment}.${var.aws_zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.rabbitmq.private_ip]
}