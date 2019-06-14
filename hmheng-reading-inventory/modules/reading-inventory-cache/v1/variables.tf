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

variable "tag_stage" {
  type = "string"
}

variable "tag_project" {
  type    = "string"
  default = "br_hmheng-reading-inventory"
}

variable "tag_cost" {
  type    = "string"
  default = "reading-inventory"
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

variable "zone_id" {
  type = "string"
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

variable "cache_id" {
  type    = "string"
  default = "ri-cache"
}

variable "cache_engine" {
  type    = "string"
  default = "redis"
}

variable "cache_engine_version" {
  type    = "string"
  default = "2.8.24"
}

variable "cache_type" {
  type    = "string"
  default = "cache.t2.micro"
}

variable "cache_parameter_group_name" {
  type    = "string"
  default = "default.redis2.8"
}

variable "cache_subnet_group_name" {
  type    = "string"
  default = "brcore01-service"
}
