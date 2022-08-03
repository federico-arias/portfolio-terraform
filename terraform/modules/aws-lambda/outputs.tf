output "lambda_invoke_arn" {
  description = "AWS ARN"
  value       = "${aws_lambda_function.function.invoke_arn}"
}

output "function_name" {
  description = "AWS ARN"
  value       = "${aws_lambda_function.function.function_name}"
}
