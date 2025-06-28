data "aws_iam_policy_document" "eks_admin" {
  statement {
    actions   = ["eks:DescribeCluster"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "eks_admin" {
  name               = "eks-admin-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_role_policy" "eks_admin_policy" {
  name   = "eks-admin-policy"
  role   = aws_iam_role.eks_admin.id
  policy = data.aws_iam_policy_document.eks_admin.json
}

data "aws_iam_policy_document" "eks_read_only" {
  statement {
    actions   = ["eks:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "eks_read_only" {
  name               = "eks-readonly-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_role_policy" "eks_read_only_policy" {
  name   = "eks-readonly-policy"
  role   = aws_iam_role.eks_read_only.id
  policy = data.aws_iam_policy_document.eks_read_only.json
}

data "aws_iam_policy_document" "assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:sub"
      values   = var.subjects
    }
  }
}
