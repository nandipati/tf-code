#####
#   Security Group Vars
#####
variable "vpc_id" {
  type    = "string"
  default = "vpc-87d95ce0"
}

variable "db_port" {
  type    = "string"
  default = "3306"
}

variable "db_protocol" {
  type    = "string"
  default = "tcp"
}

# ec2 - security group - cidr
variable "sg_cidr_internal_subnets" {
  type    = "string"
  default = "10.82.0.0/16;10.84.18.0/24;10.86.0.0/16;10.88.0.0/16;10.92.0.0/16;155.44.0.0/16;10.85.48.0/20;10.85.16.0/20;10.94.46.0/23"
}

variable "sg_cidr_bastion" {
  type    = "string"
  default = "10.32.112.0/28;10.32.116.0/28;10.32.120.0/28;10.35.2.0/24;10.35.18.0/24;10.35.34.0/24"
}

# ec2 - security group - sgid
variable "sg_id_jenkinsagent" {
  type    = "string"
  default = "sg-b27d1ecd"
}

variable "sg_id_mesosagent" {
  type    = "string"
  default = "sg-ed73068b"
}

#####
#   Char Set
#####
variable "parameter_group_name" {
  type    = "string"
  default = "self-service-db-parameters"
}

variable "family" {
  type = "map"

  default = {
    dev  = "mysql5.6"
    int  = "mysql5.6"
    cert = "mysql5.6"
    prod = "aurora5.6"
  }
}

variable "char_set_full" {
  type    = "string"
  default = "utf8mb4"
}

variable "collation_value" {
  type    = "string"
  default = "utf8mb4_unicode_ci"
}

#####
#   Tag Vars
#####

variable "tag_stage" {
  type = "string"
}

variable "tag_cost" {
  default = ""
}

variable "tag_environment" {
  type    = "string"
  default = "brnpb"
}

#####
#   DB Instance Vars
#####
variable "count_mysql_instances" {
  type = "map"

  default = {
    dev  = "1"
    int  = "1"
    cert = "1"
    prod = "0"
  }
}

variable "db_identifier" {
  type    = "string"
  default = "auth-self-service-setup"
}

variable "db_engine" {
  type    = "string"
  default = "mysql"
}

variable "db_allocated_storage" {
  type    = "string"
  default = "5"
}

variable "instance_class" {
  type = "map"

  default = {
    dev  = "db.t2.micro"
    int  = "db.t2.micro"
    cert = "db.t2.small"
    prod = "db.t2.small"
  }
}

variable "db_name" {
  type    = "string"
  default = "auth_self_service_setup"
}

variable "db_username" {
  type    = "string"
  default = "auth_self_serv"
}

variable "db_pwd" {
  type = "map"

  default = {
    dev  = "1jsnKPajjs74xHD9HdlkGuh17"
    int  = "61yYkw3ZDH76RSJAS124ybVus"
    cert = "VhmltP4zPVhWuPa8QRwkAhHZd"
    prod = "sJgW8fuXkgc3uuAccMGehNNvL"
  }
}

variable "db_subnet_group_name" {
  type    = "string"
  default = "brcore01_service"
}

#####
#   Cluster Vars
#####

variable "parameter_cluster_group_name" {
  type    = "string"
  default = "self-service-db-cluster-parameters"
}

variable "count_aurora_clusters" {
  type = "map"

  default = {
    dev  = "0"
    int  = "0"
    cert = "0"
    prod = "1"
  }
}

variable "count_aurora_cluster_instances" {
  type = "map"

  default = {
    dev  = "0"
    int  = "0"
    cert = "0"
    prod = "2"
  }
}

variable "backup_retention_period" {
  default = 5
}
