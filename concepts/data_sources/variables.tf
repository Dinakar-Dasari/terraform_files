variable "AMI_id" {
  description = "Value of the AM id"
  type        = string
  default     = "ami-09c813fb71547fc4f"
}

variable "instance_type" {
  description = "type of the instance"
  type        = string
  default     = "t3.micro"
}

variable "tags" {
  description = "tag of the instance"
  type        = map
  default     = { Name = "frontend" }
}

variable "security"{
  description = "security of the instance"
  type        = string
  default     = "security_terraform"
}

variable "from_port"{
  description = "from port"
  type = number
  default     = 0
}

variable "project" {
  default = "roboshop"
}

variable "to_port"{
  description = "to port"
  default     = 0
}

variable "sg_cdr"{
  description = "cidr"
  default     = ["0.0.0.0/0"]
}

variable "sg_ipv6"{
  description = "tipv6"
  default     = ["::/0"]
}