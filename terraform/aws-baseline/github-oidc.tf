# GitHub Actions gets short-lived AWS credentials via OIDC instead of stored
# access keys. Nothing to leak, nothing to rotate.

data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

data "aws_iam_policy_document" "github_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    # Only this repo, only the main branch. A fork or a PR branch can't assume it.
    # (The classic mistake is "repo:*" or a wildcard branch here.)
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repository}:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "github_ci" {
  name                 = "medipay-github-ci"
  assume_role_policy   = data.aws_iam_policy_document.github_trust.json
  max_session_duration = 3600
}

# Least privilege: CI may only upload evidence (SBOMs, scan reports) to one prefix.
data "aws_iam_policy_document" "ci_upload_evidence" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::medipay-audit-evidence-lab/ci/*"]
  }
}

resource "aws_iam_policy" "ci_upload_evidence" {
  name   = "medipay-ci-upload-evidence"
  policy = data.aws_iam_policy_document.ci_upload_evidence.json
}

resource "aws_iam_role_policy_attachment" "ci_upload_evidence" {
  role       = aws_iam_role.github_ci.name
  policy_arn = aws_iam_policy.ci_upload_evidence.arn
}
