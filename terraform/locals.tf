locals {
  project = "${var.environment}-${var.project}"

  default_tags = {
    Environment = var.environment
    Project     = var.project
    Region      = var.aws_region
  }
}
