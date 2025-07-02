module "sg_frontend" {
  source      = "../../module/security_group"
  description = "Creating security group for fronted dev"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  environment = var.environment
  project     = var.project
  client      = var.client
  sg_name     = var.security_name
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

# resource "aws_security_group_rule" "private_ingress" {
#   count = length(var.private_sg)
#   type              = "ingress"
#   from_port         = var.private_sg[count.index]
#   to_port           = var.private_sg[count.index]
#   protocol          = "tcp"
#   source_security_group_id = module.bastion.sg_id
#   #security_group_id = data.aws_ssm_parameter.bastion_sg_id.value   
#   security_group_id = module.private.sg_id    ##as from same folder i can use this instead of data sources
# }

# resource "aws_security_group_rule" "private_egress" {
#   count = length(var.private_sg)
#   type              = "egress"
#   from_port         = var.private_sg[count.index]
#   to_port           = var.private_sg[count.index]
#   protocol          = "tcp"
#   source_security_group_id = module.bastion.sg_id
#   #security_group_id = data.aws_ssm_parameter.bastion_sg_id.value   
#   security_group_id = module.private.sg_id    ##as from same folder i can use this instead of data sources
# }

resource "aws_security_group_rule" "backend_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
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
  source_security_group_id = module.backend_alb.sg_id     ##TO allow access from the VPN SG_ID
  security_group_id        = module.catalogue.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "catalogue_vpn" {
  count                    = length(var.catalogue_vpn)  
  type                     = "ingress"
  from_port                = var.catalogue_vpn[count.index]
  to_port                  = var.catalogue_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.VPN.sg_id     ##TO allow access from the VPN SG_ID
  security_group_id        = module.catalogue.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "catalogue_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id     ##TO allow access from the VPN SG_ID
  security_group_id        = module.catalogue.sg_id ##as from same folder i can use this instead of data sources
}

resource "aws_security_group_rule" "catalogue_mongodb" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = module.catalogue.sg_id      ##TO allow access from the VPN SG_ID
  security_group_id        = module.mongo_db.sg_id ##as from same folder i can use this instead of data sources
}


