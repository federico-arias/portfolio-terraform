output "cluster_name" {
  value = aws_eks_cluster.this.id
}

output "eks_loadbalancer_controler_role_arn" {
  value = aws_iam_role.eks_lb_controller.arn
}
