# Current project variables
variable "aurora_role" {
  type    = "string"
  default = "hmheng-support-ops"
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
  default = "obo"
}

variable "app_name" {
  type    = "string"
  default = "barcode_orders"
}

variable "cost" {
  type    = "string"
  default = "support-ops-obo"
}

variable "contact" {
  type    = "string"
  default = "fadhel.chaabane@hmhco.com"
}

# cache
variable "cache_port" {
  type    = "string"
  default = "6379"
}

variable "cache_node_count" {
  type    = "string"
  default = "1"
}

variable "cache_cluster_id" {
  type    = "string"
  default = "obo-redis"
}

variable "cache_engine" {
  type    = "string"
  default = "redis"
}

variable "cache_engine_version" {
  type    = "string"
  default = "3.2.4"
}

variable "cache_type" {
  type = "map"

  default = {
    dev    = "cache.t2.micro"
    int    = "cache.t2.micro"
    cert   = "cache.t2.micro"
    certrv = "cache.t2.micro"
    prodrv = "cache.t2.micro"
    prod   = "cache.t2.micro"
  }
}

variable "cache_parameter_group_name" {
  type    = "string"
  default = "default.redis3.2"
}

variable "cache_subnet_group_name" {
  type    = "string"
  default = "brcore01-es"
}

# vpc
variable "vpc_id" {
  type    = "string"
  default = "vpc-87d95ce0"
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

variable "tag_project" {
  type    = "string"
  default = "hmheng-support-ops_barcode_orders"
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

variable "br_aws_account_number" {
  type    = "string"
  default = "711638685743"
}

# DNS variables
variable "dns_zone_id" {
  type = "map"

  default = {
    dev    = "Z1EHTM4U1ZZVN5"
    int    = "Z2FKVQGIN9K9I"
    cert   = "Z1W6LLKXJV9SZL"
    cert2  = "Z1UBHBTDF1PMLK"
    certrv = "Z2Z4XJMRZ0UOWH"
    prodrv = "Z23RJSTB6BALM"
    uat    = "Z2PIUJERW9MHNA"
    prod   = "Z2WUOZOGBH83LP"
  }
}

variable "dns_sub_stage" {
  type = "map"

  default = {
    dev  = ".dev"
    uat  = ".uat"
    prod = ""
  }
}
