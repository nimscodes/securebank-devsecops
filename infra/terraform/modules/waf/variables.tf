variable "name_prefix" {
  description = "Name prefix used for WAF resources."
  type        = string
}

variable "alb_arn" {
  description = "Public ALB ARN to associate with the Web ACL."
  type        = string
}

variable "managed_rule_action" {
  description = "How managed WAF rule groups are enforced. Use count for monitor mode or block for normal rule actions."
  type        = string
  default     = "count"

  validation {
    condition     = contains(["count", "block"], var.managed_rule_action)
    error_message = "managed_rule_action must be count or block."
  }
}

variable "managed_rule_groups" {
  description = "AWS managed WAF rule groups attached to the Web ACL."
  type = list(object({
    name        = string
    metric_name = string
    priority    = number
  }))
  default = [
    {
      name        = "AWSManagedRulesCommonRuleSet"
      metric_name = "common"
      priority    = 10
    },
    {
      name        = "AWSManagedRulesKnownBadInputsRuleSet"
      metric_name = "known-bad-inputs"
      priority    = 20
    },
    {
      name        = "AWSManagedRulesAmazonIpReputationList"
      metric_name = "ip-reputation"
      priority    = 30
    },
    {
      name        = "AWSManagedRulesSQLiRuleSet"
      metric_name = "sqli"
      priority    = 40
    }
  ]
}

variable "tags" {
  description = "Tags applied to WAF resources."
  type        = map(string)
  default     = {}
}
