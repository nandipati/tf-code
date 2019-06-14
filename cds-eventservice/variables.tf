# vpc
variable "vpc_id" {
  type    = "string"
  default = "vpc-e477f680"
}

variable "sg_cidr_bastion" {
  type    = "string"
  default = "10.32.112.0/28;10.32.116.0/28;10.32.120.0/28;10.35.2.0/24;10.35.18.0/24;10.35.34.0/24"
}

variable "sg_id_mesosagent" {
  type    = "string"
  default = "sg-ed73068b"
}

variable "tag_environment" {
  type    = "string"
  default = "brnpb"
}

variable "tag_stage" {
  type = "string"
}

variable "tag_project" {
  type    = "string"
  default = "br_hmheng-cds_eventservice"
}

variable "tag_cost" {
  default = "cds_eventservice"
}

variable "sg_egress_protocol_all" {
  type    = "string"
  default = "-1"
}

variable "sg_egress_port_all" {
  type    = "string"
  default = "0"
}

variable "sg_cidr_all" {
  type    = "string"
  default = "0.0.0.0/0"
}

variable "lambda_count" {
  type = "map"

  default = {
    dev  = "1"
    int  = "1"
    cert = "1"
    prod = "1"
  }
}

# kinesis streams
variable "shard_count" {
  type = "map"

  default = {
    dev    = "2"
    int    = "2"
    cert   = "4"
    certrv = "1"
    prodrv = "1"
    prod   = "4"
  }
}

variable "retention_period" {
  type    = "string"
  default = "168"
}

variable "s3_data_exp" {
  type = "map"

  default = {
    dev  = "30"
    int  = "60"
    cert = "365"
    prod = "730"
  }
}

variable "dub_acct_id" {
  type = "map"

  default = {
    dev  = "205685244378"
    int  = "205685244378"
    cert = "205685244378"
    prod = "763216113038"
  }
}

variable "edanalytics_acct_id" {
  type = "map"

  default = {
    dev  = "678473142136"
    int  = "678473142136"
    cert = "678473142136"
    prod = "678473142136"
  }
}


