output "cluster_name" {
  value = aws_eks_cluster.this.id
}

output "eks_loadbalancer_controler_role_arn" {
  value = data.aws_iam_role.eks_lb_controller.arn
}

output "sops_kms_key_arn" {
  value = aws_kms_key.sops.arn
}

output "database_connection_string" {
  value     = local.database_connection_string
  sensitive = true
}
