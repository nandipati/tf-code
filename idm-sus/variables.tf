variable "tag_environment" {
  type = "string"
  default = "brnpb"
}
variable "tag_stage" {
  type = "string"
}
variable "tag_project" {
  type = "string"
  default = "br_hmheng-idm_sus"
}

# sqs
variable "visibility_timeout_seconds" {
  type = "string"
  default = "180"
}
variable "message_retention_seconds" {
  type = "string"
  default = "345600"
}
variable "max_message_size" {
  type = "string"
  default = "262144"
}
variable "receive_wait_time_seconds" {
  type = "string"
  default = "20"
}
variable "delay_seconds" {
  type = "string"
  default = "0"
}

# vpc
variable "vpc_dub" {
  type = "map"
  default = {
    dev = "205685244378"
    int = "205685244378"
    cert = "205685244378"
    certrv = "205685244378"
    prodrv = "763216113038"
    prod = "763216113038"
  }
}
