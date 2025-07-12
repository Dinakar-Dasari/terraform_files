variable "instance" {
  default = "t2.micro"
}

variable "tag" {
  default = {
    Name = "roboshop-instance"
  }
}