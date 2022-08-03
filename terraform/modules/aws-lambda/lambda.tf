resource "aws_lambda_function" "function" {
  function_name = "${var.service_name}"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_bucket_object.key

  timeout = var.timeout

  runtime = "nodejs14.x"
  handler = "main.handler" # filename + . + exported function name

  source_code_hash = data.archive_file.lambda_source.output_base64sha256

  role = aws_iam_role.lambda_exec.arn

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = var.env_variables
  }
}

resource "aws_cloudwatch_log_group" "lambda_log" {
  name = "/aws/lambda/${aws_lambda_function.function.function_name}"

  retention_in_days = 14
}
