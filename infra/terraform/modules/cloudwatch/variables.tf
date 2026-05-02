variable "web_log_group_name" {
  description = "CloudWatch log group name for web ECS tasks."
  type        = string
}

variable "api_log_group_name" {
  description = "CloudWatch log group name for API ECS tasks."
  type        = string
}

variable "retention_in_days" {
  description = "CloudWatch log retention period."
  type        = number
  default     = 14
}

variable "tags" {
  description = "Tags applied to log groups."
  type        = map(string)
  default     = {}
}
