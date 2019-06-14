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
  default = "brcore01"
}

variable "tag_stage" {
  type = "string"
}

variable "tag_project" {
  type    = "string"
  default = "br_hmheng-datascience"
}

variable "tag_cost" {
  type    = "string"
  default = "datascience"
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
  type    = "string"
  default = "db.t2.micro"
}

variable "db_port" {
  type    = "string"
  default = "5432"
}

variable "db_engine" {
  type    = "string"
  default = "postgres"
}

variable "db_engine_version" {
  type    = "string"
  default = "9.6.3"
}

variable "db_multi_az" {
  type    = "string"
  default = "True"
}

variable "db_identifier" {
  type    = "string"
  default = "ds-notebooks"
}

variable "db_allocated_storage" {
  type    = "string"
  default = "10"
}

variable "db_name" {
  type    = "string"
  default = "dsNotebooksDb"
}

variable "db_username" {
  type    = "string"
  default = "datascience_admin"
}

variable "db_password" {
  type        = "string"
  default     = "HObwCtvd|3B9*KePanIshzT5uG0FX!)L"
  description = "minimum 32 character string containing numbers, letters, and special characters"
}

variable "db_subnet_group_name" {
  type    = "string"
  default = "brcore01_infra"
}

variable "db_parameter_group_name" {
  type    = "string"
  default = "default.postgres9.6"
}
