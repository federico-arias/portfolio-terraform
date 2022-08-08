module "migrator" {
  source = "github.com/federico-arias/terraform-aws-lambda"

  service_name       = "${var.project}-${var.environment}-migrator"
  source_dir         = "/home/federico/Proyectos/komet/infrastructure/database-migrator"
  api_id             = aws_apigatewayv2_api.main_gateway.id
  api_execution_arn  = aws_apigatewayv2_api.main_gateway.execution_arn
  private_subnets    = module.vpc.private_subnets
  security_group_ids = [module.app_security_group.security_group_id]
  timeout            = 45

  env_variables = {
    DATABASE_URL = local.database_connection_string
  }


  depends_on = [aws_apigatewayv2_api.main_gateway]
}
