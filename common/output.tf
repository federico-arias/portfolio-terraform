output "frontend_repo" {
  value = aws_ecr_repository.frontend.repository_url
}

output "backend_repo" {
  value = aws_ecr_repository.backend.repository_url
}

/*
output "certificate_arn" {
  value = [for c in module.aws_acm_certificate.cert : c.arn]
}
*/

output "certificate_arn" {
  value = [module.certificate.certificate_arn, module.certificate_east_1.certificate_arn]
}
