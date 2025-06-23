# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az_names = slice(data.aws_availability_zones.available.names,0,2)
  #slice because it will give 6 regions but i need only first 2
}