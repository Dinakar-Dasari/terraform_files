variable "client" {
  default = "frontend"
}

variable "security_name" {
  default = "Sg-dev-frontend"
}

variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "bastion_name" {
  default = "bastion"
}

variable "private_subnet" {
  default = "private_ec2"
}

variable "egress_bastion" {
  default = [22, 80, 443]
}

variable "private_sg" {
  default = [22, 80, 443]
}

variable "vpn" {
  default = [22, 443, 1194, 943]
}

variable "mongodb_ports_vpn" {
  default = [22, 27017]
}


variable "redis_ports_vpn" {
  default = [22, 6379]
}

variable "mysql_ports_vpn" {
  default = [22, 3306]
}

variable "rabbitmq_ports_vpn" {
  default = [22, 5672]
}

variable "backend_vpn" {
  default = [22, 8080]
}