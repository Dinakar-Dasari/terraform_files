variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "bastion_name" {
  default = "bastion"
}

variable "databases" {
  default = ["mongodb", "mysql", "rabbitmq", "redis"]
}


variable "aws_zone_id" {
  default = "Z02485381IKGKKF8Y47H9"
}

variable "aws_zone_name" {
  default = "jiony.xyz"
}