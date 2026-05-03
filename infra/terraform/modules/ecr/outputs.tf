output "web_repository_name" {
  description = "Web ECR repository name."
  value       = aws_ecr_repository.this["web"].name
}

output "web_repository_url" {
  description = "Web ECR repository URL."
  value       = aws_ecr_repository.this["web"].repository_url
}

output "web_repository_arn" {
  description = "Web ECR repository ARN."
  value       = aws_ecr_repository.this["web"].arn
}

output "api_repository_name" {
  description = "API ECR repository name."
  value       = aws_ecr_repository.this["api"].name
}

output "api_repository_url" {
  description = "API ECR repository URL."
  value       = aws_ecr_repository.this["api"].repository_url
}

output "api_repository_arn" {
  description = "API ECR repository ARN."
  value       = aws_ecr_repository.this["api"].arn
}

output "repository_arns" {
  description = "All ECR repository ARNs."
  value       = [for repository in aws_ecr_repository.this : repository.arn]
}
