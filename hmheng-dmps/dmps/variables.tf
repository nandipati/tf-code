variable "tag_stage" {
  type = "string"
}

variable "db-pwd" {
  type = "map"

  default = {
    dev  = "W2dqFngtPDrbXMfm"
    int  = "9nMjUkBxGYWhnisyB"
    cert = "optpxfkZdzuMcQoxkocP2Hs"
    prod = "PTGsvZp9GakghezPrANnaZBTaU"
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

variable "tag_cost" {
  type    = "string"
  default = "dmps"
}

variable "instance_class_by_stage" {
  type = "map"

  default = {
    dev  = "db.t2.micro"
    int  = "db.t2.micro"
    cert = "db.r3.large"
    prod = "db.r3.large"
  }
}

variable "multi_az_by_stage" {
  type = "map"

  default = {
    dev  = false
    int  = false
    cert = true
    prod = true
  }
}

variable "storage_by_stage" {
  type = "map"

  default = {
    dev  = 5
    int  = 5
    cert = 20
    prod = 100
  }
}

variable "read_replicas_by_stage" {
  type = "map"

  default = {
    dev  = 0
    int  = 0
    cert = 1
    prod = 2
  }
}
