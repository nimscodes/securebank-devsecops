locals {
  github_oidc_url = "https://token.actions.githubusercontent.com"

  allowed_subjects = [
    "repo:${var.github_repository}:ref:refs/heads/${var.github_branch}",
    "repo:${var.github_repository}:pull_request"
  ]

  backend_bucket_arn = "arn:aws:s3:::${var.terraform_state_bucket_name}"
  backend_table_arn  = "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${var.terraform_lock_table_name}"

  ecs_cluster_arn             = "arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:cluster/${var.name_prefix}-cluster"
  api_task_definition_arn     = "arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:task-definition/${var.name_prefix}-api:*"
  ecs_task_execution_role_arn = "arn:aws:iam::${var.aws_account_id}:role/${var.name_prefix}-ecs-execution-role"
  ecs_task_role_arn           = "arn:aws:iam::${var.aws_account_id}:role/${var.name_prefix}-ecs-task-role"
}

resource "aws_iam_openid_connect_provider" "github" {
  url = local.github_oidc_url

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = var.thumbprint_list

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-github-oidc"
  })
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = local.allowed_subjects
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "${var.name_prefix}-github-actions-role"
  description        = "OIDC role used by GitHub Actions for SecureBank CI and plan preparation."
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

data "aws_iam_policy_document" "github_actions" {
  statement {
    sid    = "EcrAuth"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "EcrPushPull"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]

    resources = var.ecr_repository_arns
  }

  statement {
    sid    = "TerraformReadOnlyPlan"
    effect = "Allow"

    actions = [
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "application-autoscaling:Describe*",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "dynamodb:DescribeTable",
      "ec2:Describe*",
      "ecr:Describe*",
      "ecr:GetLifecyclePolicy",
      "ecr:GetRepositoryPolicy",
      "ecs:Describe*",
      "ecs:List*",
      "elasticloadbalancing:Describe*",
      "iam:Get*",
      "iam:List*",
      "kms:DescribeKey",
      "logs:Describe*",
      "logs:FilterLogEvents",
      "logs:Get*",
      "logs:List*",
      "rds:Describe*",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecrets",
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:GetEncryptionConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:GetPublicAccessBlock",
      "s3:ListBucket",
      "sts:GetCallerIdentity"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "TerraformStateBackend"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${local.backend_bucket_arn}/${var.terraform_state_key_prefix}/*"
    ]
  }

  statement {
    sid    = "TerraformStateBucketList"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      local.backend_bucket_arn
    ]
  }

  statement {
    sid    = "TerraformStateLocking"
    effect = "Allow"

    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem"
    ]

    resources = [
      local.backend_table_arn
    ]
  }

  statement {
    sid    = "ReadEcsMigrationTaskState"
    effect = "Allow"

    actions = [
      "ecs:DescribeServices",
      "ecs:DescribeTasks"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "RunEcsMigrationTask"
    effect = "Allow"

    actions = [
      "ecs:RunTask"
    ]

    resources = [
      local.api_task_definition_arn
    ]

    condition {
      test     = "ArnEquals"
      variable = "ecs:cluster"
      values   = [local.ecs_cluster_arn]
    }
  }

  statement {
    sid    = "StopEcsMigrationTask"
    effect = "Allow"

    actions = [
      "ecs:StopTask"
    ]

    resources = [
      "arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:task/${var.name_prefix}-cluster/*"
    ]
  }

  statement {
    sid    = "PassEcsTaskRolesForMigration"
    effect = "Allow"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      local.ecs_task_execution_role_arn,
      local.ecs_task_role_arn
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "github_actions" {
  name        = "${var.name_prefix}-github-actions-policy"
  description = "Least-privilege preparation policy for SecureBank GitHub Actions."
  policy      = data.aws_iam_policy_document.github_actions.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions.arn
}
