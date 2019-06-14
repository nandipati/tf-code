# vpc
variable "vpc_id" {
  type    = "string"
  default = "vpc-87d95ce0"
}

variable "sg_cidr_bastion" {
  type    = "string"
  default = "10.32.112.0/28;10.32.116.0/28;10.32.120.0/28;10.35.2.0/24;10.35.18.0/24;10.35.34.0/24"
}

variable "sg_id_mesosagent" {
  type    = "string"
  default = "sg-ed73068b"
}

variable "tag_environment" {
  type    = "string"
  default = "brnpb"
}

variable "tag_stage" {
  type = "string"
}

variable "tag_project" {
  type    = "string"
  default = "br_hmheng-assessments"
}

variable "tag_cost" {
  type    = "string"
  default = "assessments"
}

variable "sg_egress_protocol_all" {
  type    = "string"
  default = "-1"
}

variable "sg_egress_port_all" {
  type    = "string"
  default = "0"
}

variable "sg_cidr_all" {
  type    = "string"
  default = "0.0.0.0/0"
}

# database
variable "db_class" {
  type = "map"

  default = {
    dev = "db.t2.micro"
    int = "db.t2.micro"
  }
}

variable "db_port" {
  type    = "string"
  default = "5432"
}

variable "db_engine" {
  type    = "string"
  default = "postgres"
}

variable "db_engine_version" {
  type = "map"

  default = {
    dev = "9.6.6"
    int = "9.6.6"
  }
}

variable "db_multi_az" {
  type    = "string"
  default = "True"
}

variable "db_identifier" {
  type    = "string"
  default = "assessments-web"
}

variable "db_allocated_storage" {
  type = "map"

  default = {
    dev = "5"
    int = "5"
  }
}

variable "db_name" {
  type    = "string"
  default = "assessments_web"
}

variable "db_username" {
  type    = "string"
  default = "assessments_web_admin"
}

variable "db_password" {
  type = "map"

  default = {
    dev = "RGYFsNTUFL{ipBPuxmUHyWzLNCvtfNcpLj2gXojuA8BMwuRGen"
    int = "uTvQgXRfviCrykWHwFCFMZkxMNqVJnNLchjKyg)3gKDafme9Nf"
  }
}

variable "db_subnet_group_name" {
  type    = "string"
  default = "brcore01_service"
}

variable "db_parameter_group_name" {
  type = "map"

  default = {
    dev = "default.postgres9.6"
    int = "default.postgres9.6"
  }
}
