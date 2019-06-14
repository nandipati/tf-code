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
    default = "dev"
}
variable "tag_project" {
    type = "string"
    default = "br_hmheng-isg_pcs"
}
variable "tag_cost" {
    default = "isg-pcs"
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
    default = "3306"
}
variable "db_engine" {
    type = "string"
    default = "mysql"
}
variable "db_engine_version" {
    type = "string"
    default = "5.6.27"
}
variable "db_multi_az" {
    type = "string"
    default = "True"
}
variable "db_identifier" {
    type = "string"
    default = "isg-pcs"
}
variable "db_allocated_storage"{
    type = "string"
    default = "5"
}
variable "db_name"{
    type = "string"
    default = "pcs"
}
variable "db_username"{
    type = "string"
    default = "isg_pcs"
}
variable "db_password"{
    type = "string"
    default = "D)3ivZP!QizAIQhf8fgsf%nt0sZxTmmz"
    description = "minimum 32 character string containing numbers, letters, and special characters"
}
variable "db_subnet_group_name"{
    type = "string"
    default = "brnp-east-b"
}
variable "db_parameter_group_name"{
    type = "string"
    default = "default.mysql5.6"
}

# sqs

variable "visibility_timeout_seconds"{
    type = "string"
    default = "30"
}
variable "message_retention_seconds"{
    type = "string"
    default = "345600"
}
variable "max_message_size"{
    type = "string"
    default = "262144"
}
variable "receive_wait_time_seconds"{
    type = "string"
    default = "0"
}
variable "delay_seconds"{
    type = "string"
    default = "0"
}
