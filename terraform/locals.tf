locals {
  project = "${var.environment}-${var.project}"

  default_tags = {
    Project     = var.project
    Environment = var.environment
    Region      = var.aws_region
  }
}
