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
    default = "br_hmheng-idm_ids"
}
variable "tag_cost" {
  default = "idm_ids"
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
variable "vpc_dub" {
    type = "map"
    default = {
        dev = "205685244378"
        int = "205685244378"
        cert = "205685244378"
        certrv = "205685244378"
        prodrv = "763216113038"
        prod = "763216113038"
    }
}
variable "dns_zone_id" {
  type = "map"
  default = {
    dev = "Z1EHTM4U1ZZVN5"
    int = "Z2FKVQGIN9K9I"
    cert = "Z1W6LLKXJV9SZL"
    cert2 =  "Z1UBHBTDF1PMLK"
    certrv = "Z2Z4XJMRZ0UOWH"
    prodrv = "Z23RJSTB6BALM"
    prod = "Z2WUOZOGBH83LP"
  }
}

# database
variable "db_class" {
  type = "map"
  default = {
    dev  = "db.t2.micro"
    int  = "db.t2.micro"
    cert = "db.m4.2xlarge"
    prod = "db.m4.2xlarge"
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
    type = "string"
    default = "9.5.10"
}
variable "db_multi_az" {
    type = "string"
    default = "True"
}
variable "db_identifier" {
    type = "string"
    default = "idm-ids"
}
variable "db_allocated_storage" {
  type = "map"
  default = {
    dev  = "5"
    int  = "50"
    cert = "400"
    prod = "400"
  }
}
variable "db_backup_retention_period" {
  type = "map"
  default = {
    dev  = "0"
    int  = "0"
    cert = "5"
    prod = "5"
  }
}
variable "db_name"{
    type = "string"
    default = "ids"
}
variable "db_username"{
    type = "string"
    default = "idm_ids"
}
variable "db_password"{
    type = "string"
    default = "4Q3A2yX_mfz%K_fF^E9Q#jK-3_w6tGx?"
    description = "minimum 32 character string containing numbers, letters, and special characters"
}
variable "db_subnet_group_name"{
    type = "string"
    default = "brnp-east-b"
}
variable "db_parameter_group_name" {
  type = "map"
  default = {
    dev  = "default.postgres9.5"
    int  = "int-ids-9-5"
    cert = "default.postgres9.5"
    prod = "default.postgres9.5"
  }
}

# cache
variable "cache_port" {
    type = "string"
    default = "6379"
}
variable "cache_node_count" {
  type = "map"
  default = {
    dev  = "1"
    int  = "1"
    cert = "1"
    prod = "1"
  }
}
variable "cache_id" {
    type = "string"
    default = "idm-ids"
}
variable "cache_engine" {
    type = "string"
    default = "redis"
}
variable "cache_engine_version" {
    type = "string"
    default = "2.8.24"
}
variable "cache_type" {
  type = "map"
  default = {
    dev  = "cache.t2.micro"
    int  = "cache.t2.micro"
    cert = "cache.r3.2xlarge"
    prod = "cache.r3.2xlarge"
  }
}
variable "cache_parameter_group_name" {
    type = "string"
    default = "default.redis2.8"
}
variable "cache_subnet_group_name"{
    type = "string"
    default = "brnp-east-b"
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
