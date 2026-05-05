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

output "alb_dns_name" {
  description = "ALB DNS name."
  value       = module.alb.alb_dns_name
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
