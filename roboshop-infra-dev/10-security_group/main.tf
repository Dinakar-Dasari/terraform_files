module "frontend" {
  source      = "../../module/security_group"
  description = "Creating security group for fronted dev"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = "frontend"
  sg_name     = "frontend"
}

module "bastion" {
  source      = "../../module/security_group"
  description = "Creating security group for fronted dev"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = var.bastion_name
  sg_name     = var.bastion_name
}

module "backend_alb" {
  source      = "../../module/security_group"
  description = "Creating security group for backend alb"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = "backend"
  sg_name     = "alb"
}

module "VPN" {
  source      = "../../module/security_group"
  description = "Creating security group for vpn"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = "ROBOSHOP"
  sg_name     = "vpn"
}

module "mongo_db" {
  source      = "../../module/security_group"
  description = "Creating security group for mongodb"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = "mongodb"
  sg_name     = "mongodb"
}

module "redis_db" {
  source      = "../../module/security_group"
  description = "Creating security group for redis"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = "redisdb"
  sg_name     = "redisdb"
}

module "mysql_db" {
  source      = "../../module/security_group"
  description = "Creating security group for mysql"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = "mysqldb"
  sg_name     = "mysqldb"
}

module "rabbitmq" {
  source      = "../../module/security_group"
  description = "Creating security group for rabbitmq"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = "rabbitmq"
  sg_name     = "rabbitmq"
}

module "catalogue" {
  source      = "../../module/security_group"
  description = "Creating security group for catalogue"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = "catalogue"
  sg_name     = "catalogue"
}

module "user" {
  source      = "../../module/security_group"
  description = "Creating security group for user"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = "user"
  sg_name     = "user"
}

module "cart" {
  source      = "../../module/security_group"
  description = "Creating security group for cart"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = "cart"
  sg_name     = "cart"
}

module "shipping" {
  source      = "../../module/security_group"
  description = "Creating security group for shipping"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = "shipping"
  sg_name     = "shipping"
}

module "payment" {
  source      = "../../module/security_group"
  description = "Creating security group for payment"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = "payment"
  sg_name     = "payment"
}

module "frontend_alb" {
  source      = "../../module/security_group"
  description = "Creating security group for frontend_alb"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = "frontend_alb"
  sg_name     = "frontend_alb"
}

resource "aws_security_group_rule" "bastion_ingress" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #security_group_id = data.aws_ssm_parameter.bastion_sg_id.value   
  security_group_id = module.bastion.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "bastion_egress" {
  count       = length(var.egress_bastion)
  type        = "egress"
  from_port   = var.egress_bastion[count.index]
  to_port     = var.egress_bastion[count.index]
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #security_group_id = data.aws_ssm_parameter.bastion_sg_id.value   
  security_group_id = module.bastion.sg_id ##as from same folder i can use this instead of data sources
}

# backend_alb
resource "aws_security_group_rule" "backend_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.backend_alb.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "frontend_backendalb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id        = module.backend_alb.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "cart_backend_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id        = module.backend_alb.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "shipping_backend_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id        = module.backend_alb.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "payment_backend_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id        = module.backend_alb.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "vpn" {
  count             = length(var.vpn)
  type              = "ingress"
  from_port         = var.vpn[count.index]
  to_port           = var.vpn[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.VPN.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "alb_vpn" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.VPN.sg_id         ##TO allow access from the VPN SG_ID
  security_group_id        = module.backend_alb.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "mongodb" {
  count                    = length(var.mongodb_ports_vpn)
  type                     = "ingress"
  from_port                = var.mongodb_ports_vpn[count.index]
  to_port                  = var.mongodb_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.VPN.sg_id      ##TO allow access from the VPN SG_ID
  security_group_id        = module.mongo_db.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "redisdb" {
  count                    = length(var.redis_ports_vpn)
  type                     = "ingress"
  from_port                = var.redis_ports_vpn[count.index]
  to_port                  = var.redis_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.VPN.sg_id      ##TO allow access from the VPN SG_ID
  security_group_id        = module.redis_db.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "mysql" {
  count                    = length(var.mysql_ports_vpn)
  type                     = "ingress"
  from_port                = var.mysql_ports_vpn[count.index]
  to_port                  = var.mysql_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.VPN.sg_id      ##TO allow access from the VPN SG_ID
  security_group_id        = module.mysql_db.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "rabbitmq" {
  count                    = length(var.rabbitmq_ports_vpn)
  type                     = "ingress"
  from_port                = var.rabbitmq_ports_vpn[count.index]
  to_port                  = var.rabbitmq_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.VPN.sg_id      ##TO allow access from the VPN SG_ID
  security_group_id        = module.rabbitmq.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "catalogue_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id ##TO allow access from the VPN SG_ID
  security_group_id        = module.catalogue.sg_id   ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "catalogue_vpn" {
  count                    = length(var.backend_vpn)
  type                     = "ingress"
  from_port                = var.backend_vpn[count.index]
  to_port                  = var.backend_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.VPN.sg_id       ##TO allow access from the VPN SG_ID
  security_group_id        = module.catalogue.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "catalogue_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id   ##TO allow access from the VPN SG_ID
  security_group_id        = module.catalogue.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "catalogue_mongodb" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = module.catalogue.sg_id ##TO allow access from the VPN SG_ID
  security_group_id        = module.mongo_db.sg_id  ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "user_mongodb" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = module.user.sg_id     ##TO allow access from the VPN SG_ID
  security_group_id        = module.mongo_db.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "frontend_alb" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend_alb.sg_id
}

resource "aws_security_group_rule" "user_redisdb" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = module.user.sg_id     ##TO allow access from the VPN SG_ID
  security_group_id        = module.redis_db.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "cart_redisdb" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = module.cart.sg_id     ##TO allow access from the VPN SG_ID
  security_group_id        = module.redis_db.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "shipping_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.shipping.sg_id ##TO allow access from the VPN SG_ID
  security_group_id        = module.mysql_db.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "payment_rabbitmq" {
  type                     = "ingress"
  from_port                = 5672
  to_port                  = 5672
  protocol                 = "tcp"
  source_security_group_id = module.payment.sg_id  ##TO allow access from the VPN SG_ID
  security_group_id        = module.rabbitmq.sg_id ##as from same folder i can use this instead of data sources
}


## user rules
resource "aws_security_group_rule" "user_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id ##TO allow access from the VPN SG_ID
  security_group_id        = module.user.sg_id        ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "user_vpn" {
  count                    = length(var.backend_vpn)
  type                     = "ingress"
  from_port                = var.backend_vpn[count.index]
  to_port                  = var.backend_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.VPN.sg_id  ##TO allow access from the VPN SG_ID
  security_group_id        = module.user.sg_id ##as from same folder i can use this instead of data sources
}

## cart rules
resource "aws_security_group_rule" "cart_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id ##TO allow access from the VPN SG_ID
  security_group_id        = module.cart.sg_id        ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "cart_vpn" {
  count                    = length(var.backend_vpn)
  type                     = "ingress"
  from_port                = var.backend_vpn[count.index]
  to_port                  = var.backend_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.VPN.sg_id  ##TO allow access from the VPN SG_ID
  security_group_id        = module.cart.sg_id ##as from same folder i can use this instead of data sources
}

## payment rules
resource "aws_security_group_rule" "payment_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id ##TO allow access from the VPN SG_ID
  security_group_id        = module.payment.sg_id     ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "payment_vpn" {
  count                    = length(var.backend_vpn)
  type                     = "ingress"
  from_port                = var.backend_vpn[count.index]
  to_port                  = var.backend_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.VPN.sg_id     ##TO allow access from the VPN SG_ID
  security_group_id        = module.payment.sg_id ##as from same folder i can use this instead of data sources
}

## shipping rules
resource "aws_security_group_rule" "shipping_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id ##TO allow access from the VPN SG_ID
  security_group_id        = module.shipping.sg_id    ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "shipping_vpn" {
  count                    = length(var.backend_vpn)
  type                     = "ingress"
  from_port                = var.backend_vpn[count.index]
  to_port                  = var.backend_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.VPN.sg_id      ##TO allow access from the VPN SG_ID
  security_group_id        = module.shipping.sg_id ##as from same folder i can use this instead of data sources
}

## frontend
resource "aws_security_group_rule" "frontend_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.VPN.sg_id      ##TO allow access from the VPN SG_ID
  security_group_id        = module.frontend.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "frontend_frontalb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.frontend_alb.sg_id
  security_group_id        = module.frontend.sg_id
}


# frontend_alb

resource "aws_security_group_rule" "frontendalb_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.VPN.sg_id
  security_group_id        = module.frontend_alb.sg_id
}
