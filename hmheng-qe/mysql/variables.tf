variable "db-password" {
  type = "string"
  default = "Dublin2017"
}

# ec2 - security group - cidr
variable "sg_cidr_internal_subnets" {
  type = "string"
  default = "10.82.0.0/16;10.84.18.0/24;10.86.0.0/16;10.88.0.0/16;10.92.0.0/16;155.44.0.0/16;172.17.0.0/16"
}
variable "sg_cidr_bastion" {
    type = "string"
    default = "10.32.112.0/28;10.32.116.0/28;10.32.120.0/28;10.35.2.0/24;10.35.18.0/24;10.35.34.0/24"
}

# ec2 - security group - sgid
variable "sg_id_jenkinsagent" {
  type = "string"
  default = "sg-b27d1ecd"
}
variable "sg_id_mesosagent" {
    type = "string"
    default = "sg-ed73068b"
}

variable "tag_cost" {
  default = "hmheng-qe-mysql"
}
