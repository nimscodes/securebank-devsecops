output "web_ecr_repository_name" {
  description = "Web ECR repository name."
  value       = module.ecr.web_repository_name
}

output "web_ecr_repository_url" {
  description = "Web ECR repository URL."
  value       = module.ecr.web_repository_url
}

output "web_ecr_repository_arn" {
  description = "Web ECR repository ARN."
  value       = module.ecr.web_repository_arn
}

output "api_ecr_repository_name" {
  description = "API ECR repository name."
  value       = module.ecr.api_repository_name
}

output "api_ecr_repository_url" {
  description = "API ECR repository URL."
  value       = module.ecr.api_repository_url
}

output "api_ecr_repository_arn" {
  description = "API ECR repository ARN."
  value       = module.ecr.api_repository_arn
}

output "github_actions_role_arn" {
  description = "GitHub Actions IAM role ARN."
  value       = module.github_oidc.github_actions_role_arn
}

output "github_actions_policy_arn" {
  description = "GitHub Actions IAM policy ARN."
  value       = module.github_oidc.github_actions_policy_arn
}

output "github_oidc_provider_arn" {
  description = "GitHub Actions OIDC provider ARN."
  value       = module.github_oidc.github_oidc_provider_arn
}
