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
    default = "br_hmheng-scoring"
}
variable "tag_cost" {
    type = "string"
    default = "score_scoring"
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

# kinesis streams
variable "shard_count" {
    type = "string"
    default = "1"
}
variable "retention_period" {
    type = "string"
    default = "24"
}

variable "tag_learnosity_acc1" {
    type = "string"
    default = "acc1"
}

variable "tag_learnosity_acc2" {
    type = "string"
     default = "acc2"
}

variable "tag_learnosity_acc3" {
    type = "string"
     default = "acc3"
}

# vpc
variable "vpc_learnosity" {
  type = "map"
  default = {
    acc1 = "744999449622"
    acc2 = "767718512390"
    acc3 = "763216113038"
  }
}