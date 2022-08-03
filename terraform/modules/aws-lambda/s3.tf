resource "random_pet" "lambda_bucket_name" {
  prefix = "${var.service_name}-lambda-bucket"
  length = 1
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id

  acl           = "private"
  force_destroy = true
}

data "archive_file" "lambda_source" {
  type = "zip"

  source_dir  = "${var.source_dir}"
  output_path = "${var.source_dir}.zip"
}

resource "aws_s3_bucket_object" "lambda_bucket_object" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "${var.service_name}.zip"
  source = data.archive_file.lambda_source.output_path

  etag = filemd5(data.archive_file.lambda_source.output_path)
}
