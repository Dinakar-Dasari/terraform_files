module "ec2-instance" {
  source        = "../module/ec2_instance"
  instance_type = var.instance
  tags          = var.tag
}
