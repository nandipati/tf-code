# vpc
variable "vpc_id" {
  type = "string"
  default = "vpc-87d95ce0"
}
variable "sg_cidr_bastion" {
  type = "string"
  default = "10.32.112.0/28;10.32.116.0/28;10.32.120.0/28;10.35.2.0/24;10.35.18.0/24;10.35.34.0/24"
}
variable "sg_id_mesosagent" {
  type = "string"
  default = "sg-ed73068b"
}
variable "tag_environment" {
  type = "string"
  default = "brcore01"
}
variable "tag_project" {
  type = "string"
  default = "br_hmheng-core-services-assignment"
}
variable "tag_cost" {
  type = "string"
  default = "core_services_assignment"
}
variable "sg_egress_protocol_all" {
  type = "string"
  default = "-1"
}
variable "sg_egress_port_all" {
  type = "string"
  default = "0"
}
variable "sg_cidr_all" {
  type = "string"
  default = "0.0.0.0/0"
}
variable "shard_count" {
  type = "map"
  default = {
    dev = "1"
    int = "1"
    cert = "2"
    certrv = "1"
    prodrv = "1"
    prod = "2"
  }
}
variable "retention_period" {
  type = "string"
  default = "24"
}
variable "aurora_role" {
  type = "string"
  default = "hmheng-core-services"
}
variable "aws_region" {
  type    = "string"
  default = "us-east-1"
}
variable "app_name" {
  type    = "string"
  default = "assignment-status"
}