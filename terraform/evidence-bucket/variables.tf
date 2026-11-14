variable "use_localstack" {
  description = "Apply against LocalStack instead of real AWS."
  type        = bool
  default     = true
}

variable "bucket_name" {
  description = "Name of the audit evidence bucket (must be globally unique on real AWS)."
  type        = string
  default     = "medipay-audit-evidence-lab"
}
