variable "aurora_role" {
  type    = "string"
  default = "hmheng-ch"
}

variable "aws_region" {
  type    = "string"
  default = "us-east-1"
}

variable "stage" {
  type = "string"
}

variable "service_name" {
  type    = "string"
}

variable "calculated_behavior_read_capacity" {
  type = "string"
}

variable "calculated_behavior_write_capacity" {
  type = "string"
}

variable "class_content_read_capacity" {
  type = "string"
}

variable "class_content_write_capacity" {
  type = "string"
}

variable "class_object_read_capacity" {
  type = "string"
}

variable "class_object_write_capacity" {
  type = "string"
}

variable "cost" {
  type    = "string"
  default = "hmheng-ch"
}

variable "contact" {
  type    = "string"
  default = "slack:classhopper"
}

variable "br_aws_account_number" {
  type    = "string"
  default = "711638685743"
}
