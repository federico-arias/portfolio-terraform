# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = "${local.project}-cluster"
  role_arn = data.aws_iam_role.cluster.arn
  version  = "1.21"

  vpc_config {
    # security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
    subnet_ids              = flatten([aws_subnet.public[*].id, aws_subnet.private[*].id])
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

}

# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name        = "${local.project}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${local.project}-cluster-sg"
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "egress"
}

# Attaches permission for aws-privateca-issuer
# https://github.com/cert-manager/aws-privateca-issuer#configuration
# terragrunt state rm aws_iam_policy.ca_issuer
# resource "aws_iam_policy" "ca_issuer" {
#   name        = "cluster_ca_issuer"
#   path        = "/"
#   description = "CA Issuer for ${var.project}-${var.environment} cluster"
#
#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid = "awspcaissuer",
#         Action = [
#           "acm-pca:DescribeCertificateAuthority",
#           "acm-pca:GetCertificate",
#           "acm-pca:IssueCertificate"
#         ]
#         Effect   = "Allow"
#         Resource = data.terraform_remote_state.common.outputs.certificate_arn
#       },
#     ]
#   })
# }
#
# resource "aws_iam_role_policy_attachment" "ca_issuer" {
#   policy_arn = aws_iam_policy.ca_issuer.arn
#   role       = aws_iam_role.cluster.name
# }
