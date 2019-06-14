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
    default = "br_hmheng-content-pipeline"
}
variable "tag_cost" {
    type = "string"
    default = "content_pipeline"
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
    type = "map"
    default = {
        dev = "db.t2.micro"
        int = "db.t2.micro"
        cert = "db.t2.micro"
        prod = "db.t2.micro"
    }
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
    type = "map"
    default = {
        dev = "9.6.5"
        int = "9.6.5"
        cert = "9.6.5"
        prod = "9.6.5"
    }
}
variable "db_multi_az" {
    type = "string"
    default = "True"
}
variable "db_identifier" {
    type = "string"
    default = "content-pipeline"
}
variable "db_allocated_storage"{
    type = "map"
    default = {
        dev = "5"
        int = "5"
        cert = "5"
        prod = "5"
    }
}
variable "db_name"{
    type = "string"
    default = "content_pipeline"
}
variable "db_username"{
    type = "string"
    default = "content_pipeline_admin"
}
variable "db_password" {
    type = "map"
    default = {
        dev = "SStnha'640AOEAOEud=69[{=*!Bbsaoeut*8|bb[{}"
        int = "SStnha'640AOEAOEud=69[{=*!Bbsaoeut*8|bb[{}"
        cert = "SStnha'640AOEAOEud=69[{=*!Bbsaoeut*8|bb[{}"
        prod = "SStnha'640AOEAOEud=69[{=*!Bbsaoeut*8|bb[{}"
    }
}
variable "db_subnet_group_name"{
    type = "string"
    default = "brnp-east-b"
}
variable "db_parameter_group_name"{
    type = "map"
    default = {
        dev = "default.postgres9.6"
        int = "default.postgres9.6"
        cert = "default.postgres9.6"
        prod = "default.postgres9.6"
    }
}
