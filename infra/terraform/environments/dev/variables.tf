variable "aws_region" {
  description = "AWS region for the dev environment."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used in resource naming."
  type        = string
  default     = "securebank"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Additional tags applied to resources."
  type        = map(string)
  default = {
    Owner = "platform"
  }
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones used by the dev environment."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks."
  type        = list(string)
  default     = ["10.20.0.0/24", "10.20.1.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "Private app subnet CIDR blocks."
  type        = list(string)
  default     = ["10.20.10.0/24", "10.20.11.0/24"]
}

variable "private_db_subnet_cidrs" {
  description = "Private database subnet CIDR blocks."
  type        = list(string)
  default     = ["10.20.20.0/24", "10.20.21.0/24"]
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT gateway for private app subnet egress. Defaults false for cost control."
  type        = bool
  default     = false
}

variable "enable_private_service_endpoints" {
  description = "Whether to create VPC endpoints that let private ECS tasks reach ECR, CloudWatch Logs, Secrets Manager, and S3 without a NAT gateway."
  type        = bool
  default     = true
}

variable "alb_ingress_cidr" {
  description = "CIDR block allowed to access the ALB."
  type        = string
  default     = "0.0.0.0/0"
}

variable "certificate_arn" {
  description = "Optional ACM certificate ARN for HTTPS. Leave null for Phase 3."
  type        = string
  default     = null
}

variable "alb_deletion_protection" {
  description = "Whether ALB deletion protection is enabled."
  type        = bool
  default     = false
}

variable "enable_alb_access_logs" {
  description = "Whether to enable ALB access logging to S3. Disabled by default for dev cost and storage control."
  type        = bool
  default     = false
}

variable "alb_access_logs_bucket_name" {
  description = "Optional S3 bucket name for ALB access logs. Leave null to generate one when access logging is enabled."
  type        = string
  default     = null
}

variable "alb_access_logs_prefix" {
  description = "S3 prefix for ALB access logs."
  type        = string
  default     = "alb"
}

variable "alb_access_logs_retention_days" {
  description = "Number of days to retain ALB access logs in S3 when logging is enabled."
  type        = number
  default     = 30
}

variable "web_image" {
  description = "Container image for the web service."
  type        = string
  default     = "985059095414.dkr.ecr.us-east-1.amazonaws.com/securebank-dev-web:latest"
}

variable "api_image" {
  description = "Container image for the API service."
  type        = string
  default     = "985059095414.dkr.ecr.us-east-1.amazonaws.com/securebank-dev-api:latest"
}

variable "web_container_port" {
  description = "Web container port."
  type        = number
  default     = 3000
}

variable "api_container_port" {
  description = "API container port."
  type        = number
  default     = 4000
}

variable "web_health_check_path" {
  description = "Web health check path."
  type        = string
  default     = "/"
}

variable "api_health_check_path" {
  description = "API health check path."
  type        = string
  default     = "/health"
}

variable "web_cpu" {
  description = "Web task CPU units."
  type        = number
  default     = 256
}

variable "web_memory" {
  description = "Web task memory in MiB."
  type        = number
  default     = 512
}

variable "api_cpu" {
  description = "API task CPU units."
  type        = number
  default     = 256
}

variable "api_memory" {
  description = "API task memory in MiB."
  type        = number
  default     = 512
}

variable "web_desired_count" {
  description = "Desired web task count."
  type        = number
  default     = 1
}

variable "api_desired_count" {
  description = "Desired API task count."
  type        = number
  default     = 1
}

variable "web_environment" {
  description = "Plain environment variables for the web container."
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "NODE_ENV"
      value = "production"
    },
    {
      name  = "NEXT_PUBLIC_API_URL"
      value = "/api"
    }
  ]
}

variable "api_environment" {
  description = "Plain environment variables for the API container."
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "NODE_ENV"
      value = "production"
    },
    {
      name  = "PORT"
      value = "4000"
    }
  ]
}

variable "web_secrets" {
  description = "Secret references for the web container. Keep empty until real secrets are created."
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "api_secrets" {
  description = "Secret references for the API container. Keep empty until real secrets are created."
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "enable_container_insights" {
  description = "Whether ECS container insights are enabled."
  type        = bool
  default     = true
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention period."
  type        = number
  default     = 14
}

variable "enable_cloudwatch_alarms" {
  description = "Whether to create CloudWatch operational alarms for the dev environment."
  type        = bool
  default     = true
}

variable "alarm_actions" {
  description = "SNS topic ARNs or other action ARNs for CloudWatch alarms. Leave empty until notification routing is added."
  type        = list(string)
  default     = []
}

variable "alb_5xx_threshold" {
  description = "ALB 5xx count in one minute that triggers an alarm."
  type        = number
  default     = 5
}

variable "unhealthy_target_threshold" {
  description = "Unhealthy target count that triggers an alarm."
  type        = number
  default     = 1
}

variable "ecs_cpu_threshold" {
  description = "ECS average CPU utilization percentage that triggers an alarm."
  type        = number
  default     = 80
}

variable "ecs_memory_threshold" {
  description = "ECS average memory utilization percentage that triggers an alarm."
  type        = number
  default     = 80
}

variable "rds_cpu_threshold" {
  description = "RDS average CPU utilization percentage that triggers an alarm."
  type        = number
  default     = 80
}

variable "rds_free_storage_threshold_bytes" {
  description = "RDS free storage threshold in bytes. Default is 2 GiB."
  type        = number
  default     = 2147483648
}

variable "secret_recovery_window_in_days" {
  description = "Secrets Manager recovery window for placeholder secret containers."
  type        = number
  default     = 7
}

variable "database_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "securebank"
}

variable "database_master_username" {
  description = "RDS master username. Password is managed by AWS."
  type        = string
  default     = "securebank_admin"
}

variable "database_port" {
  description = "PostgreSQL database port."
  type        = number
  default     = 5432
}

variable "database_engine_version" {
  description = "PostgreSQL engine version."
  type        = string
  default     = "16.4"
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allocated_storage" {
  description = "Initial RDS allocated storage in GB."
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum RDS autoscaled storage in GB."
  type        = number
  default     = 100
}

variable "db_backup_retention_period" {
  description = "RDS backup retention in days."
  type        = number
  default     = 1
}

variable "db_multi_az" {
  description = "Whether the dev RDS instance is deployed across multiple availability zones."
  type        = bool
  default     = false
}

variable "db_deletion_protection" {
  description = "Whether RDS deletion protection is enabled."
  type        = bool
  default     = false
}

variable "db_skip_final_snapshot" {
  description = "Whether to skip the final DB snapshot on deletion."
  type        = bool
  default     = true
}
