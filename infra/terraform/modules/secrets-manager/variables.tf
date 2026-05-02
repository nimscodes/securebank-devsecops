variable "name_prefix" {
  description = "Name prefix used for Secrets Manager resources."
  type        = string
}

variable "recovery_window_in_days" {
  description = "Secret deletion recovery window."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags applied to secrets."
  type        = map(string)
  default     = {}
}
