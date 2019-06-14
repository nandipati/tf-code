variable "tag_environment" {
  type = "map"

  default = {
    dev  = "dev"
    int  = "int"
    cert = "cert"
    prod = "prod"
  }
}

variable "environment" {
  type = "map"

  default = {
    dev  = "dev"
    int  = "int"
    cert = "cert"
    prod = "prod"
  }
}

variable "tag_stage" {
  type = "string"
}

variable "tag_project" {
  type    = "string"
  default = "br_hmheng_idm_rostering"
}

provider "aws" {
  region = "us-east-1"
}

# sqs
variable "visibility_timeout_seconds" {
  type    = "string"
  default = "180"
}

variable "message_retention_seconds" {
  type    = "string"
  default = "345600"
}

variable "max_message_size" {
  type    = "string"
  default = "262144"
}

variable "receive_wait_time_seconds" {
  type    = "string"
  default = "20"
}

variable "delay_seconds" {
  type    = "string"
  default = "0"
}

variable "message_retry_count" {
  type    = "string"
  default = "5"
}
