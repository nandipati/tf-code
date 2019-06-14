# vpc
variable "vpc_id" {
  type = "string"
}
variable "sg_cidr_bastion" {
  type = "string"
}
variable "sg_id_mesosagent" {
  type = "string"
}
variable "tag_environment" {
  type = "string"
}
variable "tag_stage" {
  type = "string"
}
variable "tag_project" {
  type = "string"
}
variable "tag_cost" {
  type ="string"
}
variable "sg_egress_protocol_all" {
  type = "string"
}
variable "sg_egress_port_all" {
  type = "string"
}
variable "sg_cidr_all" {
  type = "string"
}
# kinesis stream
variable "shard_count" {
  type = "string"
}
variable "retention_period" {
  type = "string"
}
variable "aurora_role" {
  type = "string"
}
variable "aws_region" {
  type = "string"
}
variable "app_name" {
  type = "string"
}