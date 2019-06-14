variable "hmh_security_aws_account_number" {
  type        = "string"
  default     = "506747919528"
  description = "Account number for the HMH Security AWS account"
}

variable "environment" {
  type        = "string"
  default     = "hmh-security"
  description = "Environment identifier for HMH Security owned policies"
}
