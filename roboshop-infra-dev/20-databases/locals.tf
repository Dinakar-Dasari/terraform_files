locals {
  database_subnet = split(",", data.aws_ssm_parameter.cidr_database.value)[0]
  mongo_db        = data.aws_ssm_parameter.mongodb_sg.value
  rabbitmq        = data.aws_ssm_parameter.rabbitmq.value
  mysql           = data.aws_ssm_parameter.mysql.value
  redis           = data.aws_ssm_parameter.redis_sg.value
}