resource "aws_route53_record" "testsite" {
  count   = 4
  zone_id = var.zone_id
  #this is interpolation concept, we are ${} because we have two variables and also a string btwn them
  #so in order to combine them we need to use that syntax
  name    = "${var.instance_name[count.index]}.${var.domain}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.terraform[count.index].private_ip]
}