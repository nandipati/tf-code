variable "tag_stage" {
  type = "string"
}

variable "vpc_id" {
  type    = "string"
  default = "vpc-87d95ce0"
}

variable "db-pwd" {
  type = "map"

  default = {
    cert = "VhmltP4zPVhWuPa8QRwkAhHZd"
    prod = "sJgW8fuXkgc3uuAccMGehNNvL"
  }
}

provider "aws" {
  region = "us-east-1"
}

# ec2 - security group - cidr
variable "sg_cidr_internal_subnets" {
  type    = "string"
  default = "10.82.0.0/16;10.84.18.0/24;10.86.0.0/16;10.88.0.0/16;10.92.0.0/16;155.44.0.0/16"
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

variable "count_aurora_clusters" {
  type = "map"

  default = {
    cert = "0"
    prod = "1"
  }
}

variable "count_aurora_cluster_instances" {
  type = "map"

  default = {
    cert = "0"
    prod = "2"
  }
}

variable "count_mysql_instances" {
  type = "map"

  default = {
    cert = "1"
    prod = "0"
  }
}

variable "tag_project" {
  type    = "string"
  default = "mms"
}

variable "tag_responsible_party" {
  type    = "string"
  default = "@custom-dev-mms"
}

variable "instance_class" {
  type = "map"

  default = {
    cert = "db.t2.large"
    prod = "db.r3.large"
  }
}
