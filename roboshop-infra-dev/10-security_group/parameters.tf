resource "aws_ssm_parameter" "frontend" {
  name        = "/${var.project}/${var.environment}/${var.client}"
  description = "Stores the security group id for frontend"
  type        = "String"
  value       = module.frontend.sg_id
  tags = {
    Name = "${var.project}-${var.environment}-sg-id"
  }
}

resource "aws_ssm_parameter" "bastion_sg_id" {
  name        = "/${var.project}/${var.environment}/${var.bastion_name}_sg_id"
  description = "Stores the security group id of bastion"
  type        = "String"
  value       = module.bastion.sg_id
  tags = {
    Name = "${var.project}-${var.environment}-sg-id"
  }
}


# resource "aws_ssm_parameter" "private_sg_id" {
#   name        = "/${var.project}/${var.environment}/${var.private_subnet}_sg_id"
#   description = "Stores the security group id of private_subnet"
#   type        = "String"
#   value       = module.private.sg_id
#   tags = {
#     Name = "${var.project}-${var.environment}-private-sg-id"
# }
# }

resource "aws_ssm_parameter" "backend_alb_sg" {
  name        = "/${var.project}/backend_alb_sg"
  description = "Stores the security group id of backend_alb_sg"
  type        = "String"
  value       = module.backend_alb.sg_id
  overwrite = true
  tags = {
    Name = "${var.project}-backend-sg-id"
  }
}

resource "aws_ssm_parameter" "vpn_sg" {
  name        = "/${var.project}/roboshop_vpn"
  description = "Stores the security group id of vpn"
  type        = "String"
  value       = module.VPN.sg_id
  tags = {
    Name = "${var.project}-roboshop_vpn-sg-id"
  }
}

resource "aws_ssm_parameter" "mongo_db" {
  name        = "/${var.project}/${var.environment}/mongodb"
  description = "Stores the security group id of mongodb"
  type        = "String"
  value       = module.mongo_db.sg_id
  tags = {
    Name = "${var.project}-roboshop_vpn-sg-id"
  }
}

resource "aws_ssm_parameter" "mysql_db" {
  name        = "/${var.project}/${var.environment}/mysqldb"
  description = "Stores the security group id of mysqldb"
  type        = "String"
  value       = module.mysql_db.sg_id
  tags = {
    Name = "${var.project}-roboshop_mysqldb-sg-id"
  }
}

resource "aws_ssm_parameter" "redis_db" {
  name        = "/${var.project}/${var.environment}/redis_db"
  description = "Stores the security group id of redis_db"
  type        = "String"
  value       = module.redis_db.sg_id
  tags = {
    Name = "${var.project}-roboshop_redis_db-sg-id"
  }
}

resource "aws_ssm_parameter" "rabbitmq" {
  name        = "/${var.project}/${var.environment}/rabbitmq"
  description = "Stores the security group id of rabbitmq"
  type        = "String"
  value       = module.rabbitmq.sg_id
  tags = {
    Name = "${var.project}-roboshop_rabbitmq-sg-id"
  }
}

resource "aws_ssm_parameter" "catalogue" {
  name        = "/${var.project}/${var.environment}/catalogue"
  description = "Stores the security group id of catalogue"
  type        = "String"
  value       = module.catalogue.sg_id
  tags = {
    Name = "${var.project}-roboshop_catalogue-sg-id"
  }
}

resource "aws_ssm_parameter" "cart" {
  name        = "/${var.project}/${var.environment}/cart"
  description = "Stores the security group id of cart"
  type        = "String"
  value       = module.cart.sg_id
  tags = {
    Name = "${var.project}-roboshop_cart-sg-id"
  }
}

resource "aws_ssm_parameter" "shipping" {
  name        = "/${var.project}/${var.environment}/shipping"
  description = "Stores the security group id of shipping"
  type        = "String"
  value       = module.shipping.sg_id
  tags = {
    Name = "${var.project}-roboshop_shipping-sg-id"
  }
}

resource "aws_ssm_parameter" "payment" {
  name        = "/${var.project}/${var.environment}/payment"
  description = "Stores the security group id of payment"
  type        = "String"
  value       = module.payment.sg_id
  tags = {
    Name = "${var.project}-roboshop_payment-sg-id"
  }
}

resource "aws_ssm_parameter" "user" {
  name        = "/${var.project}/${var.environment}/user"
  description = "Stores the security group id of user"
  type        = "String"
  value       = module.user.sg_id
  tags = {
    Name = "${var.project}-roboshop_user-sg-id"
  }
}

resource "aws_ssm_parameter" "frontend_alb_sg" {
  name        = "/${var.project}/${var.environment}/frontend_alb_sg"
  description = "Stores the security group id of frontend_alb"
  type        = "String"
  value       = module.frontend_alb.sg_id
  overwrite = true
  tags = {
    Name = "${var.project}-frontend_alb-sg-id"
  }
}