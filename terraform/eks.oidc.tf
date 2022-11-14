locals {
  oidc_provider = try(replace(aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", ""), "")
}

data "aws_partition" "current" {}

data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}



resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list = distinct(compact(concat(
    ["sts.amazonaws.com"],
  )))
  thumbprint_list = concat(
    [data.tls_certificate.this.certificates[0].sha1_fingerprint],
    [],
    #var.custom_oidc_thumbprints
  )
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "eks" {
  depends_on = [aws_iam_openid_connect_provider.oidc_provider]

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

  }
}
/*
resource "aws_iam_role" "eks_lb_controller" {
  name               = "AmazonEKSLoadBalancerControllerRole"
  assume_role_policy = data.aws_iam_policy_document.eks.json
}

resource "aws_iam_policy" "eks_lb_controller" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("aws_load_balancer_controller_policy.json")
}
*/

data "aws_iam_role" "eks_lb_controller" {
  name = "AmazonEKSLoadBalancerControllerRole"
}
data "aws_iam_policy" "eks_lb_controller" {
  name = "AWSLoadBalancerControllerIAMPolicy"
}



resource "aws_iam_role_policy_attachment" "eks_lb" {
  role       = data.aws_iam_role.eks_lb_controller.name
  policy_arn = data.aws_iam_policy.eks_lb_controller.arn
}

/*
module "lb_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "${local.project}_eks_lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = aws_iam_openid_connect_provider.oidc_providers.arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}
 * Is all this provided by "iam-role-for-service-accounts-eks" module?
*/
