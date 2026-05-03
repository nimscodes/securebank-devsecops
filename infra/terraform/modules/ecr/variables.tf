variable "web_repository_name" {
  description = "ECR repository name for the web image."
  type        = string
}

variable "api_repository_name" {
  description = "ECR repository name for the API image."
  type        = string
}

variable "image_tag_mutability" {
  description = "ECR image tag mutability setting."
  type        = string
  default     = "IMMUTABLE"
}

variable "max_tagged_images" {
  description = "Maximum tagged images retained per repository."
  type        = number
  default     = 30
}

variable "untagged_image_expiration_days" {
  description = "Days to retain untagged images."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags applied to ECR resources."
  type        = map(string)
  default     = {}
}
