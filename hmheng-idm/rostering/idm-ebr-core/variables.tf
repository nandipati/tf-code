variable "vpc_id" {
  type    = "string"
  default = "vpc-87d95ce0"
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

variable "parameter_group_name" {
  type    = "string"
  default = "ebr-core-service-db-parameters"
}

variable "family" {
  type = "map"

  default = {
    dev  = "mysql5.7"
    int  = "mysql5.7"
    cert = "aurora5.7"
    prod = "aurora5.7"
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
  default = "idm-rstr-ebr"
}

variable "db_engine" {
  type    = "string"
  default = "mysql"
}

variable "db_engine_version" {
  type    = "string"
  default = "5.7.21"
}

variable "db_class" {
  type = "map"

  default = {
    dev  = "db.t2.small"
    int  = "db.t2.small"
    cert = "db.t2.medium"
    prod = "db.t2.medium"
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
  default = "idm_rstr_ebr"
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
  default = "brcore01_service"
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
  default = "idm-rstr-ebr"
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

variable "parameter_cluster_group_name" {
  type    = "string"
  default = "ebr-service-db-cluster-parameters"
}
