variable "stage" {
  type = "string"
}

variable "vpc_id" {
  type    = "string"
  default = "vpc-87d95ce0"
}

variable "db_username" {
  type = "string"
}

variable "db_password" {
  type = "string"
}

variable "db_class" {
  type = "string"
}

variable "db_allocated_storage" {
  type = "string"
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

variable "sg_id_mesosagent" {
  type    = "string"
  default = "sg-ed73068b"
}

variable "tag_project" {
  type    = "string"
  default = "hmheng-customdev-chiroapi"
}

variable "tag_responsible_party" {
  type    = "string"
  default = "@custom-dev-chiro"
}
