output "app_config_secret_arn" {
  description = "ARN for the application configuration secret container."
  value       = aws_secretsmanager_secret.app_config.arn
}

output "database_config_secret_arn" {
  description = "ARN for the database configuration secret container."
  value       = aws_secretsmanager_secret.database_config.arn
}
