variable "vpc_id" {
  type        = "string"
  default     = "vpc-e477f680"
  description = "bedrock vpc"
}

variable "vpc_region" {
  default = "us-east-1"
}

variable "tag_stage" {
  type = "string"
}
