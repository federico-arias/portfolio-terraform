resource "aws_apigatewayv2_api" "main_gateway" {
  name          = "${var.project}-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "main_gateway_stage" {
  api_id = aws_apigatewayv2_api.main_gateway.id

  name        = "${var.project}-api-gateway-stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.main_gateway.name}"

  retention_in_days = 30
}
