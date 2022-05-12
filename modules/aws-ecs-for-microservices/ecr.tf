resource "aws_ecr_repository" "repository" {
  name                 = ${var.service_name}
  image_tag_mutability = "IMMUTABLE"
}
