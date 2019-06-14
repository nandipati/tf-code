variable "vpc-id" {
    type = "string"
    default = "vpc-e477f680"
}
variable "project-name" {
    type = "string"
    default = "io.hmheng.blog"
    }
variable "db-class" {
        type = "string"
    default = "db.t1.micro"
}
variable "db-username" {
    type = "string"
    default = "wp_admin"
}
variable "db-password" {
    type = "string"
    default = "backward-flotsam-potsherd"
}
variable "db-name" {
  type = "string"
  default = "blog"
}
variable "db_subnet-name" {
  type = "string"
  default = "brnp-east-b"
}


provider "aws" {
    region="us-east-1"
}
variable "tag_cost" {
  default = "blog"
}
variable "cidr_bastion" {
  type = "list"
  default = [
    "10.32.112.0/28",
    "10.32.116.0/28",
    "10.32.120.0/28"
  ]
}
variable "cidr_internal" {
  type = "list"
  default = [
    "10.0.0.0/8",
    "155.44.0.0/17",
    "172.17.0.0/17"
  ]
}
variable "tag_environment" {
  default = "brnpb"
}
