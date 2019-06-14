variable "tag_stage" {
  type = "string"
}

variable "vpc-id" {
  type = "map"
  default = {
    int = "vpc-e477f680"
    cert = "vpc-e477f680"
    prod = "vpc-e477f680"
  }
}

variable "db-pwd" {
  type = "map"
  default = {
    dev     = "Rf09P964Mali"
    int     = "U02z18v7gjvw"
    cert    = "61yYkw3ZzgTXFfwmxh0wSr612"
    prod    = "7u4xZ8Ai0H4zc6tOZc0Yuq56f"  
  }
}

provider "aws" {
  region = "us-east-1"
}

# ec2 - security group - cidr
variable "sg_cidr_internal_subnets" {
  type = "string"
  default = "10.82.0.0/16;10.84.18.0/24;10.86.0.0/16;10.88.0.0/16;10.92.0.0/16;155.44.0.0/16;10.85.48.0/20;10.85.16.0/20;10.94.46.0/23"
}
variable "sg_cidr_bastion" {
    type = "string"
    default = "10.32.112.0/28;10.32.116.0/28;10.32.120.0/28;10.35.2.0/24;10.35.18.0/24;10.35.34.0/24"
}

# ec2 - security group - sgid
variable "sg_id_jenkinsagent" {
  type = "string"
  default = "sg-b27d1ecd"
}
variable "sg_id_mesosagent" {
    type = "string"
    default = "sg-ed73068b"
}

variable "count_aurora" {
     type = "map"
    default = {
         dev = "0"
         int = "0"
         cert = "1"
         prod = "1"
     }
 }

 variable "count_aurora_replicas" {
     type = "map"
    default = {
         dev = "0"
         int = "0"
         cert = "2"
         prod = "2"
     }
 }

 variable "count_rds" {
     type = "map"
    default = {
         dev = "1"
         int = "1"
         cert = "0"
         prod = "0"
     }
 }

variable "cluster_ids" {
  type = "map"
  default = {
    cert    = "aws_rds_cluster.idm-user-api-cluster-cert.id"
    prod    = "aws_rds_cluster.idm-user-api-cluster-prod.id"  
  }
}
variable "tag_cost" {
    type = "string"
    default = "idm_user_api"
}

variable "instance_class" {
  type = "map"
  default = {
    dev   = "db.t1.micro"
    int   = "db.m1.small"
    cert   = "db.r3.large"
    prod   = "db.r3.large"
  }
}
