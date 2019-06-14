# vpc
variable "vpc_id" {
    type = "string"
    default = "vpc-e477f680"
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
    default = "brnpb"
}
variable "tag_stage" {
    type = "string"
}
variable "tag_project" {
    type = "string"
    default = "br_hmheng-report-data-services"
}
variable "tag_cost" {
    type = "string"
    default = "report_data_services"
}
variable "sg_egress_protocol_all" {
    type = "string"
    default = "-1"
}
variable "sg_egress_port_all" {
    type = "string"
    default = "0"
}

# kinesis streams
variable "shard_count" {
  type = "map"

  default = {
    dev = "2"
    int = "2"
    cert = "2"
    prod = "2"
  }
}

variable "retention_period" {
    type = "string"
    default = "24"
}
