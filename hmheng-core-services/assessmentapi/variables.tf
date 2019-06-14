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
variable "tag_stage" {
  type = "string"
}
variable "tag_project" {
  type = "string"
  default = "br_hmheng-core-services-assessment"
}
variable "tag_cost" {
    type = "string"
    default = "core_services_assessment"
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


# cache
variable "cache_port" {
  type = "string"
  default = "6379"
}
variable "cache_node_count" {
  type = "string"
  default = "1"
}
variable "cache_id" {
  type = "string"
  default = "assessmentapi"
}
variable "cache_engine" {
  type = "string"
  default = "redis"
}
variable "cache_engine_version" {
  type = "string"
  default = "3.2.4"
}
variable "cache_type" {
  type = "map"
  default = {
    dev = "cache.t2.micro"
    int = "cache.t2.micro"
    cert = "cache.t2.micro"
    certrv = "cache.t2.micro"
    prodrv = "cache.t2.micro"
    prod = "cache.t2.micro"
  }
}
variable "cache_parameter_group_name" {
  type = "string"
  default = "default.redis3.2"
}
variable "cache_subnet_group_name"{
  type = "string"
  default = "brcore01-es"
}
