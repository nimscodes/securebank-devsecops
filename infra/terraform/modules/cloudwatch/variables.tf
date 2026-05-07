variable "web_log_group_name" {
  description = "CloudWatch log group name for web ECS tasks."
  type        = string
}

variable "api_log_group_name" {
  description = "CloudWatch log group name for API ECS tasks."
  type        = string
}

variable "name_prefix" {
  description = "Name prefix used for CloudWatch alarms."
  type        = string
}

variable "retention_in_days" {
  description = "CloudWatch log retention period."
  type        = number
  default     = 14
}

variable "enable_alarms" {
  description = "Whether CloudWatch operational alarms are created."
  type        = bool
  default     = true
}

variable "alarm_actions" {
  description = "SNS topic ARNs or other action ARNs invoked when alarms change state. Leave empty until notification routing is added."
  type        = list(string)
  default     = []
}

variable "alb_arn_suffix" {
  description = "ALB ARN suffix for ApplicationELB CloudWatch dimensions."
  type        = string
}

variable "target_groups" {
  description = "Target group ARN suffixes keyed by service name."
  type        = map(string)
  default     = {}
}

variable "ecs_cluster_name" {
  description = "ECS cluster name for ECS CloudWatch dimensions."
  type        = string
}

variable "ecs_services" {
  description = "ECS service names keyed by service role."
  type        = map(string)
  default     = {}
}

variable "rds_instance_identifier" {
  description = "RDS DB instance identifier for RDS CloudWatch dimensions."
  type        = string
}

variable "alb_5xx_threshold" {
  description = "Number of ALB 5xx errors in one minute that triggers an alarm."
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

variable "tags" {
  description = "Tags applied to log groups."
  type        = map(string)
  default     = {}
}
