output "web_log_group_name" {
  description = "Web ECS log group name."
  value       = aws_cloudwatch_log_group.web.name
}

output "api_log_group_name" {
  description = "API ECS log group name."
  value       = aws_cloudwatch_log_group.api.name
}

output "alarm_names" {
  description = "CloudWatch operational alarm names."
  value = concat(
    [for alarm in aws_cloudwatch_metric_alarm.alb_5xx : alarm.alarm_name],
    [for alarm in aws_cloudwatch_metric_alarm.target_unhealthy : alarm.alarm_name],
    [for alarm in aws_cloudwatch_metric_alarm.ecs_cpu : alarm.alarm_name],
    [for alarm in aws_cloudwatch_metric_alarm.ecs_memory : alarm.alarm_name],
    [for alarm in aws_cloudwatch_metric_alarm.rds_cpu : alarm.alarm_name],
    [for alarm in aws_cloudwatch_metric_alarm.rds_free_storage : alarm.alarm_name]
  )
}
