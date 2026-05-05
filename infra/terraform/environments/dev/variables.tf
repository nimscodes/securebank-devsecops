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

variable "web_image" {
  description = "Placeholder container image for the web service."
  type        = string
  default     = "replace-me/securebank-web:latest"
}

variable "api_image" {
  description = "Placeholder container image for the API service."
  type        = string
  default     = "replace-me/securebank-api:latest"
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

variable "database_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "database_allocated_storage" {
  description = "Initial RDS allocated storage in GB."
  type        = number
  default     = 20
}

variable "database_max_allocated_storage" {
  description = "Maximum RDS autoscaled storage in GB."
  type        = number
  default     = 100
}

variable "database_backup_retention_period" {
  description = "RDS backup retention in days."
  type        = number
  default     = 7
}

variable "database_deletion_protection" {
  description = "Whether RDS deletion protection is enabled."
  type        = bool
  default     = true
}

variable "database_skip_final_snapshot" {
  description = "Whether to skip the final DB snapshot on deletion."
  type        = bool
  default     = false
}
