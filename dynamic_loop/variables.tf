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
  type        = map(any)
  default     = { Name = "frontend" }
}

variable "security" {
  description = "security of the instance"
  type        = string
  default     = "security_terraform"
}

variable "from_port" {
  description = "from port"
  type        = number
  default     = 0
}

variable "to_port" {
  description = "to port"
  default     = 0
}

variable "sg_cdr" {
  description = "cidr"
  default     = ["0.0.0.0/0"]
}

variable "sg_ipv6" {
  description = "tipv6"
  default     = ["::/0"]
}

variable "instance_name" {
  default = {
    "mongodb" = "t3.micro"
    "redis"   = "t2.micro"
    "cart"    = "t3.micro"
    "mysql"   = "t2.small"
  }
}

variable "zone_id" {
  default = "Z02485381IKGKKF8Y47H9"
}

variable "domain" {
  default = "jiony.xyz"
}

variable "ingress_block" {
  default = [
    {
      from_port = 22 #list of map
      to_port   = 22
    },
    {
      from_port = 443
      to_port   = 443
    },
    {
      from_port = 80
      to_port   = 80
    }
  ]
}