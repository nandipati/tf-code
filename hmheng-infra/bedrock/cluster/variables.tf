variable "vpc_id" {
  description = "brnpa/brnpb VPC ID"
}

variable "vpc_abbrev" {
  description = "brnpa or brnpb"
}

variable "vpc_region" {
  default = "us-east-1"
}

variable "account_number" {
  description = "AWS account number"
  default     = "711638685743"
}

variable "key_pair" {
  description = "Name of the standard EC2 SSH key-pair"
  default = "tf-brcore01-shared-key"
}

variable "brnpb_jenkins_slave_role_arn" {
  default = "arn:aws:iam::711638685743:role/infra-jenkins-buildslave-role"
}
