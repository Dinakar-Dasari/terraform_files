variable "ami_id" {
    default = "ami-09c813fb71547fc4f"
    type = string
    description = "ami-id of the instance"
}

variable "instance_type" {
    type = string
    description = "instance type"
    #default = "t2.micro"
    validation {
    condition = contains(["t2.micro","t3.micro","t2.small"], var.instance_type)
    error_message = "Invalid instance type. Only ('t2.micro','t3.micro','t2.small') are allowed."
    }
}

variable "tags" {
    type = map
    default = {
        Name = "Module"
    }
}