resource "random_pet" "lambda_bucket_name" {
  prefix = "learn-terraform-functions"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id

  acl           = "private"
  force_destroy = true
}

# zips a dir
data "archive_file" "lambda_source" {
  type = "zip"

  source_dir  = "${path.module}/fn"
  output_path = "${path.module}/hello-world.zip"
}

resource "aws_s3_bucket_object" "lambda_hello_world" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "hello-world.zip"
  source = data.archive_file.lambda_source.output_path

  etag = filemd5(data.archive_file.lambda_source.output_path)
}
