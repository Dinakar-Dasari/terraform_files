module "git" {
  source = "git::https://github.com/Dustboy743/terraform_files.git//module/ec2_instance"
  instance_type = "t2.micro" 
}