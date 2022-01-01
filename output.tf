output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.main.address
}

output "postgres_url" {
  description = "connection string"
  value       = "postgres://${aws_db_instance.main.username}:@${aws_db_instance.main.address}:5432/postgres"
  sensitive = true
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

output "region" {
  value = var.region
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
