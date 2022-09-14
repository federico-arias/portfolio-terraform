module "lb_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "${var.project}_eks_lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_policy" "lb_controller" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("iam_policy.json")
}

data "aws_iam_policy_document" "eks" {
  depends_on = [module.eks]

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

  }
}

resource "aws_iam_role" "eks_lb_controller" {
  name               = "AmazonEKSLoadBalancerControllerRole"
  assume_role_policy = data.aws_iam_policy_document.eks.json
}

resource "aws_iam_role_policy_attachment" "eks_lb" {
  role       = aws_iam_role.eks_lb_controller.name
  policy_arn = aws_iam_policy.lb_controller.arn
}
