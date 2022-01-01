output "api_gateway_url" {
  value = "https://${aws_apigatewayv2_api.lambda.id}.execute-api.${var.region}.amazonaws.com/${var.lambda_stage}"
}
