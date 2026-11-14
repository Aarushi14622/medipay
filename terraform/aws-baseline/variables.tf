variable "github_repository" {
  description = "The only GitHub repo allowed to assume the CI role (owner/name)."
  type        = string
  default     = "Aarushi14622/medipay"
}

variable "budget_alert_email" {
  description = "Where budget alerts go. Set this in a local tfvars file; don't commit a real address."
  type        = string
  default     = "security-alerts@example.com"
}

variable "monthly_budget_usd" {
  description = "Alert when forecast spend passes this amount."
  type        = string
  default     = "10"
}
