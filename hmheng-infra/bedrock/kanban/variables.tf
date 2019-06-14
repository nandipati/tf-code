# vpc
variable "vpc_id" {
    type = "string"
    default = "vpc-e477f680"
}
variable "sg_cidr_bastion" {
    type = "string"
    default = "10.32.112.0/28;10.32.116.0/28;10.32.120.0/28;10.35.2.0/24;10.35.18.0/24;10.35.34.0/24"
}
variable "sg_cidr_mesos_prod_a" {
    type = "string"
    default = "10.32.99.128/25;10.32.103.128/25;10.32.107.128/25"
}
variable "sg_cidr_mesos_prod_b" {
    type = "string"
    default = "10.32.115.128/25;10.32.119.128/25;10.32.123.128/25"
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
variable "tag_cost" {
    type = "string"
    default = "kanboard"
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


# database
variable "db_class" {
    type = "string"
    default = "db.t2.micro"
}
variable "db_port" {
    type = "string"
    default = "5432"
}
variable "db_engine" {
    type = "string"
    default = "postgres"
}
variable "db_engine_version" {
    type = "string"
    default = "9.5.2"
}
variable "db_multi_az" {
    type = "string"
    default = "True"
}
variable "db_identifier" {
    type = "string"
    default = "infra-kanban"
}
variable "db_allocated_storage"{
    type = "string"
    default = "5"
}
variable "db_name"{
    type = "string"
    default = "kanban"
}
variable "db_username"{
    type = "string"
    default = "br_kanban"
}
variable "db_password"{
    type = "string"
    default = "gAVY3wyHhBsS3cGkAnwEuXeBAbh8FZFX"
    description = "minimum 32 character string containing numbers, letters, and special characters"
}
variable "db_subnet_group_name"{
    type = "string"
    default = "brnp-east-b"
}
variable "db_parameter_group_name"{
    type = "string"
    default = "default.postgres9.5"
}
