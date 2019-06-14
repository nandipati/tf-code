variable "tag_stage" {
  type = "string"
}

provider "aws" {
  region = "us-east-1"
}

variable "tag_br_id" {
  type    = "string"
  default = "711638685743"
}

# sqs
variable "visibility_timeout_seconds" {
  type    = "string"
  default = "3600"
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

# vpc
variable "vpc_dub" {
  type = "map"

  default = {
    dev    = "205685244378"
    int    = "205685244378"
    cert   = "205685244378"
    certrv = "205685244378"
    prodrv = "763216113038"
    prod   = "763216113038"
  }
}

variable "tag_environment" {
  type = "map"

  default = {
    dev  = "dev"
    int  = "int"
    cert = "cert"
    prod = "prod"
  }
}
