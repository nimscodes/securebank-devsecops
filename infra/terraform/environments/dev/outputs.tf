output "vpc_id" {
  description = "Dev VPC ID."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private app subnet IDs."
  value       = module.vpc.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private DB subnet IDs."
  value       = module.vpc.private_db_subnet_ids
}

output "vpc_endpoint_ids" {
  description = "Private service VPC endpoint IDs."
  value       = var.enable_private_service_endpoints ? module.vpc_endpoints[0].interface_endpoint_ids : null
}

output "alb_dns_name" {
  description = "ALB DNS name."
  value       = module.alb.alb_dns_name
}

output "alb_access_logs_bucket_name" {
  description = "ALB access log bucket name when access logging is enabled."
  value       = module.alb.access_logs_bucket_name
}

output "cloudwatch_alarm_names" {
  description = "CloudWatch operational alarm names."
  value       = module.cloudwatch.alarm_names
}

output "waf_web_acl_name" {
  description = "WAF Web ACL name when WAF is enabled."
  value       = var.enable_waf ? module.waf[0].web_acl_name : null
}

output "waf_web_acl_arn" {
  description = "WAF Web ACL ARN when WAF is enabled."
  value       = var.enable_waf ? module.waf[0].web_acl_arn : null
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = module.ecs.cluster_name
}

output "web_service_name" {
  description = "Web ECS service name."
  value       = module.ecs.web_service_name
}

output "api_service_name" {
  description = "API ECS service name."
  value       = module.ecs.api_service_name
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint."
  value       = module.rds.db_endpoint
}

output "rds_master_user_secret_arn" {
  description = "AWS-managed RDS master user secret ARN."
  value       = module.rds.master_user_secret_arn
  sensitive   = true
}

output "app_config_secret_arn" {
  description = "Placeholder app config secret ARN."
  value       = module.secrets_manager.app_config_secret_arn
}

output "database_config_secret_arn" {
  description = "Placeholder database config secret ARN."
  value       = module.secrets_manager.database_config_secret_arn
}
