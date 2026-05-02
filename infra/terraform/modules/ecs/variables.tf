variable "name_prefix" {
  description = "Name prefix used for ECS resources."
  type        = string
}

variable "aws_region" {
  description = "AWS region used by CloudWatch log configuration."
  type        = string
}

variable "private_app_subnet_ids" {
  description = "Private application subnet IDs used by ECS services."
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID attached to ECS services."
  type        = string
}

variable "web_target_group_arn" {
  description = "ALB target group ARN for the web service."
  type        = string
}

variable "api_target_group_arn" {
  description = "ALB target group ARN for the API service."
  type        = string
}

variable "web_image" {
  description = "Placeholder container image for the web service."
  type        = string
}

variable "api_image" {
  description = "Placeholder container image for the API service."
  type        = string
}

variable "web_container_port" {
  description = "Web container port."
  type        = number
}

variable "api_container_port" {
  description = "API container port."
  type        = number
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
  description = "Desired web service task count."
  type        = number
  default     = 1
}

variable "api_desired_count" {
  description = "Desired API service task count."
  type        = number
  default     = 1
}

variable "web_log_group_name" {
  description = "CloudWatch log group name for web task logs."
  type        = string
}

variable "api_log_group_name" {
  description = "CloudWatch log group name for API task logs."
  type        = string
}

variable "web_environment" {
  description = "Plain environment variables for the web container."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "api_environment" {
  description = "Plain environment variables for the API container."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "web_secrets" {
  description = "Secret references for the web container."
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "api_secrets" {
  description = "Secret references for the API container."
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

variable "tags" {
  description = "Tags applied to ECS resources."
  type        = map(string)
  default     = {}
}
