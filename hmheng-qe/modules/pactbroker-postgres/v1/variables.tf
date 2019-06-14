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

variable "stage" {
  type = "string"
}

variable "tag_project" {
  type    = "string"
  default = "br-hmheng-qe"
}

variable "tag_cost" {
  type    = "string"
  default = "hmheng-qe-pactbroker-postgres"
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

# database
variable "db_class" {
  type = "string"
}

variable "db_port" {
  type    = "string"
  default = "5432"
}

variable "db_engine" {
  type    = "string"
  default = "postgres"
}

variable "db_multi_az" {
  type    = "string"
  default = "False"
}

variable "db_identifier" {
  type    = "string"
  default = "hmheng-qe-pactbroker-db"
}

variable "db_allocated_storage" {
  type = "string"
}

variable "db_name" {
  type    = "string"
  default = "pactbroker"
}

variable "db_username" {
  type = "string"
}

variable "db_password" {
  type = "string"
}

variable "db_subnet_group_name" {
  type    = "string"
  default = "brcore01_service"
}

variable "db_parameter_group_family" {
  type    = "string"
  default = "postgres10"
}

variable "db_parameter_group_name" {
  type    = "string"
  default = "default.postgres10"
}

variable "db_backup_retention_period" {
  type    = "string"
  default = "10"
}