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
    default = "brnpb"
}
variable "stage" {
    type = "string"
}
variable "tag_project" {
    type = "string"
    default = "br-hmheng-scoring"
}
variable "tag_cost" {
    type = "string"
    default = "hmheng-score-scoring"
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
}
variable "db_multi_az" {
    type = "string"
    default = "false"
}
variable "db_identifier" {
    type = "string"
    default = "hmheng-scoring-ccas"
}
variable "db_allocated_storage"{
    type = "string"
}
variable "db_name"{
    type = "string"
    default = "ccas"
}
variable "db_username"{
    type = "string"
}
variable "db_password" {
    type = "string"
}
variable "db_subnet_group_name"{
    type = "string"
    default = "brcore01_service"
}
variable "db_parameter_group_name"{
    type = "string"
    default = "default.postgres9.3"
}
variable "db_parameter_group_family"{
    type = "string"
    default = "postgres9.3"
}

variable "db_parameter_max_wal_senders"{
    type = "string"
}
variable "db_parameter_max_standby_streaming_delay"{
    type = "string"
}
variable "db_parameter_statement_timeout"{
    type = "string"
}
variable "db_backup_retention_period"{
    type = "string"
    default = "10"
}
variable "db_create_from_snapshot"{
     type = "string"
     default = ""
}
variable "db_auto_minor_version_upgrade"{
     type = "string"
     default = "false"
}