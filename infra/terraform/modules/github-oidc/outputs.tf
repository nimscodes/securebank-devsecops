output "github_oidc_provider_arn" {
  description = "GitHub Actions OIDC provider ARN."
  value       = aws_iam_openid_connect_provider.github.arn
}

output "github_actions_role_arn" {
  description = "GitHub Actions IAM role ARN."
  value       = aws_iam_role.github_actions.arn
}

output "github_actions_policy_arn" {
  description = "GitHub Actions IAM policy ARN."
  value       = aws_iam_policy.github_actions.arn
}
