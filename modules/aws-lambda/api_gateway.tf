resource "aws_apigatewayv2_integration" "lambda" {
  #api_id = aws_apigatewayv2_api.lambda.id
  api_id = var.api_id

  integration_uri    = aws_lambda_function.function.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "hello_world" {
  #api_id = aws_apigatewayv2_api.lambda.id
  api_id = var.api_id

  route_key = "${var.method} ${var.path}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_execution_arn}/*/*"
}
