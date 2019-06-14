# bedrock aws account
variable "br_aws_account_number" {
  type    = "string"
  default = "711638685743"
}

# static infrastructure vpc
variable "core_vpc_region" {
  type    = "string"
  default = "us-east-1"
}

variable "core_vpc_abbrev" {
  type    = "string"
  default = "brcore01"
}

variable "core_vpc_id" {
  type    = "string"
  default = "vpc-87d95ce0"
}

variable "cluster_vpc_id" {
  type    = "string"
  default = "vpc-e477f680"
}

variable "core_infrastructure_project_tag" {
  type    = "string"
  default = "core_infra"
}

variable "jenkins_prod" {
  default = 1
}

variable "tag_cost" {
  default = "br_infra"
}

variable "consul_bucket_name" {
  default = "br-consul-backup"
}

variable "artifactory_bucket_name" {
  default = "br-artifactory"
}

variable "combined_env_abbrev" {
  default     = "br"
  description = "Environment abbreviation to define all prod or all dev (ie. [brcore01, brnpb, brnpa] = br)"
}
