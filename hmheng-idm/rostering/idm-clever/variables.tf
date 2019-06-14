variable "stage" {
  type = "map"

  default = {
    int  = "brnpb"
    cert = "brnpb"
    prod = "brnpb"
  }
}

variable "environment" {
  type = "string"
}

#variable "environment" {
#  type = "map"
#
#  default = {
#    dev  = "dev"
#    int  = "int"
#    cert = "cert"
#    prod = "prod"
#  }
#}

variable "sg_id_ebr" {
  type = "map"

  default = {
    dev  = "205685244378/sg-8ae30ff3"
    int  = "205685244378/sg-27bd555e"
    cert = "205685244378/sg-95c589ec"
    prod = "763216113038/sg-ab9fcfd2"
  }
}

variable "ingress-cidr" {
  type    = "string"
  default = "0.0.0.0/0"
}

variable "vpc-id" {
  type = "map"

  default = {
    int  = "vpc-e477f680"
    cert = "vpc-e477f680"
    prod = "vpc-e477f680"
  }
}

variable "project-name" {
  type = "map"

  default = {
    int  = "idm-clever"
    cert = "idm-clever"
    prod = "idm-clever"
  }
}

variable "db-engine" {
  type = "map"

  default = {
    int  = "mysql"
    cert = "aurora"
    prod = "aurora"
  }
}

variable "db-class" {
  type = "map"

  default = {
    int  = "db.t1.micro"
    cert = "db.r4.2xlarge"
    prod = "db.r4.2xlarge"
  }
}

variable "db-username" {
  type = "map"

  default = {
    int  = "idm_clever"
    cert = "idm_clever"
    prod = "idm_clever"
  }
}

variable "db-password-int" {
  type    = "string"
  default = "backward-flotsam-potsherd"
}

variable "db-password-cert" {
  type    = "string"
  default = "flotsam-potsherd-backward"
}

variable "db-password-prod" {
  type    = "string"
  default = "potsherd-backward-flotsam"
}

variable "db-name" {
  type = "map"

  default = {
    int  = "idm_clever_int"
    cert = "idm_clever_cert"
    prod = "idm_clever_prod"
  }
}

variable "db-subnet-name" {
  type = "map"

  default = {
    int  = "brnp-east-b"
    cert = "brnp-east-b"
    prod = "brnp-east-b"
  }
}

variable "parameter-group-name" {
  type = "map"

  default = {
    int  = "mysql56-custom-idm-clever-int"
    cert = "default.aurora5.6"
    prod = "default.aurora5.6"
  }
}

provider "aws" {
  region = "us-east-1"
}

# ec2 - security group - cidr
variable "sg_cidr_internal_subnets" {
  type    = "string"
  default = "10.82.0.0/16;10.84.18.0/24;10.86.0.0/16;10.88.0.0/16;10.92.0.0/16;155.44.0.0/16;172.17.0.0/16"
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
  default = "idm_clever"
}
