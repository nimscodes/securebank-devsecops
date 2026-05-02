output "web_log_group_name" {
  description = "Web ECS log group name."
  value       = aws_cloudwatch_log_group.web.name
}

output "api_log_group_name" {
  description = "API ECS log group name."
  value       = aws_cloudwatch_log_group.api.name
}
