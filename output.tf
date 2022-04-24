output "secret" {
  value = aws_iam_access_key.ecr_pusher.encrypted_secret
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.main.address
}

output "postgres_url" {
  description = "connection string"
  value       = "postgres://${aws_db_instance.main.username}:${var.db_password}@${aws_db_instance.main.address}:5432/postgres"
  sensitive   = true
}

output "alb_url" {
  value = "http://${aws_lb.loadbalancer.dns_name}"
}

output "ecr_repo_frontend" {
  value = aws_ecr_repository.frontend.repository_url
}

output "ecr_repo_backend" {
  value = aws_ecr_repository.backend.repository_url
}

output "ecr_repo_landing" {
  value = aws_ecr_repository.landing.repository_url
}

output "frontend_tag" {
  value = var.frontend_tag
}

output "backend_tag" {
  value = var.backend_tag
}

output "landing_tag" {
  value = var.landing_tag
}

output "region" {
  value = var.region
}

output "project" {
  value = var.project
}

output "aws_profile" {
  value = var.aws_profile
}

output "aws_secret" {
  value = aws_iam_access_key.ecr_pusher.id
  sensitive   = true
}

output "aws_id" {
  value = aws_iam_access_key.ecr_pusher.secret
  sensitive   = true
}

/* hack to get aws account id */
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

output "account_id" {
  value = local.account_id
}
/* end of hack */
