variable "vpc_id" {
  type    = "string"
  default = "vpc-e477f680"
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

variable "sg_id_bastion" {
  type    = "string"
  default = "sg-15bcf664"
}

variable "tag_environment" {
  type = "map"

  default = {
    dev  = "dev"
    int  = "int"
    cert = "cert"
    prod = "prod"
  }
}

variable "environment" {
  type = "map"

  default = {
    dev  = "dev"
    int  = "int"
    cert = "cert"
    prod = "prod"
  }
}

variable "tag_stage" {
  type = "string"
}

variable "tag_project" {
  type    = "string"
  default = "br_hmheng_idm_rostering"
}

provider "aws" {
  region = "us-east-1"
}

variable "db_identifier" {
  type    = "string"
  default = "idm-rstr-ss"
}

variable "db_engine" {
  type    = "string"
  default = "mysql"
}

variable "db_engine_version" {
  type    = "string"
  default = "5.7.11"
}

variable "db_class" {
  type = "map"

  default = {
    dev  = "db.t2.small"
    int  = "db.t2.small"
    cert = "db.r4.large"
    prod = "db.r4.large"
  }
}

variable "db_allocated_storage" {
  type = "map"

  default = {
    dev  = "5"
    int  = "5"
    cert = "50"
    prod = "50"
  }
}

variable "db_name" {
  type    = "string"
  default = "idm_rstr_ss"
}

variable "db_multi_az" {
  type    = "string"
  default = "True"
}

variable "db_port" {
  type    = "string"
  default = "3306"
}

variable "db_username" {
  type    = "string"
  default = "idm_rstr_admin"
}

variable "db_aurora_username" {
  type = "map"

  default = {
    cert  = "idmRstrAdminCert"
    cert2 = "idmRstrAdminCert2"
    prod  = "idmRstrAdminProd"
  }
}

variable "db_password" {
  type = "map"

  default = {
    dev   = "!Qq4yHE.?>6kECt?kkGW"
    int   = "6&QzpzenT%=#E2UXEtU^"
    cert  = "!i3K_n>pmE?~#f!W%BH="
    cert2 = "vx=P}}dViX2}Y&,L>Ksw"
    prod  = "DypTAP}Yx:yEG^K!mWxF"
  }
}

variable "db_subnet_group_name" {
  type    = "string"
  default = "brnp-east-b"
}

variable "count_mysql" {
  type = "map"

  default = {
    dev  = "1"
    int  = "1"
    cert = "0"
    prod = "0"
  }
}

variable "count_aurora" {
  type = "map"

  default = {
    dev  = "0"
    int  = "0"
    cert = "1"
    prod = "1"
  }
}

variable "count_aurora_instances" {
  type = "map"

  default = {
    dev  = "0"
    int  = "0"
    cert = "2"
    prod = "2"
  }
}

variable "count_rds" {
  type = "map"

  default = {
    dev  = "1"
    int  = "1"
    cert = "0"
    prod = "0"
  }
}

variable "tag_cost" {
  type    = "string"
  default = "idm-rstr-ss"
}
