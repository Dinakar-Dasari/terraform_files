resource "aws_route53_record" "testsite" {
  for_each = aws_instance.terraform ##using output of instance.tf as the output is of type map
  zone_id  = var.zone_id
  #this is interpolation concept, we are ${} because we have two variables and also a string btwn them
  #so in order to combine them we need to use that syntax
  name    = "${each.key}.${var.domain}"
  type    = "A"
  ttl     = 1
  records = [each.value.private_ip]
}