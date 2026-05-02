variable "name_prefix" {
  description = "Name prefix used for ALB resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for target groups."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID attached to the ALB."
  type        = string
}

variable "web_container_port" {
  description = "Web container target port."
  type        = number
}

variable "api_container_port" {
  description = "API container target port."
  type        = number
}

variable "web_health_check_path" {
  description = "Health check path for the web target group."
  type        = string
  default     = "/"
}

variable "api_health_check_path" {
  description = "Health check path for the API target group."
  type        = string
  default     = "/health"
}

variable "certificate_arn" {
  description = "Optional ACM certificate ARN for HTTPS."
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "SSL policy for the optional HTTPS listener."
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "enable_deletion_protection" {
  description = "Whether deletion protection is enabled on the ALB."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to ALB resources."
  type        = map(string)
  default     = {}
}
