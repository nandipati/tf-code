variable "ami" {
  type    = "string"
  default = "ami-cb22e3dd"
}

variable vpc_id {
  type    = "string"
  default = "vpc-61793404"
}

variable "instance_type" {
  type    = "string"
  default = "t2.micro"
}

variable "stage" {
  type = "string"
}

variable "name" {
  type    = "string"
  default = "codex-server"
}

variable "ec2_as_subnets" {
  type = "list"

  default = [
    "subnet-f044e5db",
    "subnet-f4b12a83",
    "subnet-135de54a",
  ]
}

variable "ec2_elb_subnets" {
  type = "list"

  default = [
    "subnet-f244e5d9",
    "subnet-f5b12a82",
    "subnet-105de549",
  ]
}

variable "as_ec2_size" {
  type = "map"

  default = {
    max     = "5"
    min     = "3"
    desired = "3"
  }
}

variable "environment" {
  type = "map"

  default = {
    dev  = "rsnp"
    int  = "rsnp"
    cert = "rsnp"
    prod = "rspr"
  }
}

variable "ssl_cert_arn" {
  type    = "string"
  default = "arn:aws:iam::187631879586:server-certificate/hmheng_io"
}

variable "internal_subnets" {
  type = "list"

  default = [
    "172.17.0.0/17",
    "10.0.0.0/8",
  ]
}

variable "tag_cost" {
  default = "codex"
}
