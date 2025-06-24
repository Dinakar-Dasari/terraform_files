variable "tag" {
  default = "roboshop"
}
#want to test to give value directly in main.tf file

variable "environment" {
  default = {
    Name = "dev"
  }
}

variable "cidr_public" {
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "cidr_private" {
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "cidr_database" {
  default = ["10.0.4.0/24", "10.0.5.0/24"]
}