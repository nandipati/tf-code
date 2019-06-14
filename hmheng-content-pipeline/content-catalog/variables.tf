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
  default = "brcore01"
}

variable "tag_stage" {
  type = "string"
}

variable "tag_project" {
  type    = "string"
  default = "br_hmheng-content-pipeline"
}

variable "tag_cost" {
  type    = "string"
  default = "content_pipeline"
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

variable "zone_id" {
  type    = "string"
  default = "Z16OXEYM0XPXOL"
}

# database
variable "db_class" {
  type = "map"

  default = {
    dev  = "db.t2.micro"
    int  = "db.t2.micro"
    cert = "db.t2.micro"
    prod = "db.t2.micro"
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
    dev  = "9.6.6"
    int  = "9.6.6"
    cert = "9.6.6"
    prod = "9.6.6"
  }
}

variable "db_multi_az" {
  type    = "string"
  default = "True"
}

variable "db_identifier" {
  type    = "string"
  default = "content-catalog"
}

variable "db_allocated_storage" {
  type = "map"

  default = {
    dev  = "5"
    int  = "5"
    cert = "5"
    prod = "5"
  }
}

variable "db_name" {
  type    = "string"
  default = "content_catalog"
}

variable "db_username" {
  type    = "string"
  default = "content_catalog_admin"
}

variable "db_password" {
  type = "map"

  default = {
    dev  = "z56WamrfFEdPCbKUS3vPt3QUCdCBJEThxD5B2kGPdq"
    int  = "a4j6JnhmqBkAhbSPQJnKxAEYra2EG2DvVRL2Tzzgxd"
    cert = "yVBXN8FEYSgBTXbT83fRCxwF3Lu7yVTBAhXw4k7e9m"
    prod = "QrCuLsq6KRYNL8hPKyq8yDKaSu3bWNevYPm5gNSBqk"
  }
}

variable "db_subnet_group_name" {
  type    = "string"
  default = "brcore01_service"
}

variable "db_parameter_group_name" {
  type = "map"

  default = {
    dev  = "default.postgres9.6"
    int  = "default.postgres9.6"
    cert = "default.postgres9.6"
    prod = "default.postgres9.6"
  }
}

# Redis cache
variable "cache_port" {
  type    = "string"
  default = "6379"
}

variable "cache_node_count" {
  type    = "string"
  default = "1"
}

variable "cache_id" {
  type    = "string"
  default = "content-catalog"
}

variable "cache_engine" {
  type    = "string"
  default = "redis"
}

variable "cache_engine_version" {
  type    = "string"
  default = "3.2.4"
}

variable "cache_type" {
  type = "map"

  default = {
    dev  = "cache.t2.micro"
    int  = "cache.t2.micro"
    cert = "cache.t2.micro"
    prod = "cache.t2.micro"
  }
}

variable "cache_parameter_group_name" {
  type    = "string"
  default = "default.redis3.2"
}

variable "cache_subnet_group_name" {
  type    = "string"
  default = "brcore01-service"
}
