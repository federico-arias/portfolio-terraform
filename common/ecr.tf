resource "aws_ecr_repository" "backend" {
  name                 = "${var.project}-backend"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository" "frontend" {
  name                 = "${var.project}-frontend"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository" "migration" {
  name                 = "${var.project}-migration-job"
  image_tag_mutability = "IMMUTABLE"
}
