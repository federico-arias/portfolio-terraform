module "migrator" {
  source = "./modules/aws-lambda"

  service_name = "${var.project}-migrator"
  source_dir = "/home/federico/proyectos/komet/infrastructure/database-migrator"
  api_id = aws_apigatewayv2_api.main_gateway.id
  api_execution_arn = aws_apigatewayv2_api.main_gateway.execution_arn
  private_subnets = module.vpc.private_subnets
  security_group_ids = [module.app_security_group.security_group_id]
  timeout = 45

  env_variables = {
    DATABASE_URL = "postgres://${aws_db_instance.main.username}:${var.db_password}@${aws_db_instance.main.address}:5432/postgres"
  }


  depends_on = [aws_apigatewayv2_api.main_gateway]
}
