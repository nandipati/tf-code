variable "dns_domain_name" {
  description = "br zone dns name (br.internal/brdev."
}

variable "external_security_group_cidrs" {
  description = "allow external access to terraform elb"
  type = "list"
}

data "aws_acm_certificate" "terraform" {
  domain   = "terraform.${var.dns_domain_name}"
  statuses = ["ISSUED"]
}

terraform {
  required_version = ">= 0.9.3"
}

variable "fqdn" {
  description = "The fully qualified domain name the cluster is accessible as"
}

variable "hostname" {
  description = "The name the cluster will be register as under the zone (optional if separately managing DNS)"
  default     = ""
}

variable "zone_id" {
  description = "The route53 zone id to register the hostname in (optional if separately managing DNS)"
  default     = ""
}

variable "instance_subnet_id" {
  description = "Subnet to place the instance into"
}

variable "elb_subnet_id" {
  description = "Subnet that will hold the ELB"
}

variable "data_subnet_ids" {
  description = "Subnets to place the data services (RDS) into (2 required for availability)"
  type        = "list"
}

variable "db_password" {
  description = "RDS password to use"
}

variable "bucket_name" {
  description = "S3 bucket to store artifacts into"
}

variable "manage_bucket" {
  description = "Indicate if the S3 bucket should be created/owned by this terraform state"
  default     = true
}

variable "key_name" {
  description = "Keypair name to use when started the instances, leave blank for no SSH access"
  default     = ""
}

variable "db_username" {
  description = "RDS username to use"
  default     = "atlas"
}

variable "local_db" {
  description = "Use the database on the instance (alpha feature)"
  default     = false
}

variable "local_redis" {
  description = "Use redis on the instance"
  default     = true
}

variable "region" {
  description = "AWS region to place cluster into"
}

variable "ami_id" {
  description = "The AMI of a Terraform Enterprise Base image"
}

variable "ebs_size" {
  default     = 100
  description = "Size of the EBS volume"
}

variable "ebs_redundancy" {
  description = "Number of redundent EBS volumes to configure"
  default     = 2
}

variable "local_setup" {
  description = "Write the setup configuration data local, not in S3"
  default     = false
}

variable "instance_type" {
  description = "AWS instance type to use"
  default     = "m4.2xlarge"
}

data "aws_subnet" "instance" {
  id = "${var.instance_subnet_id}"
}

data "aws_vpc" "vpc" {
  id = "${data.aws_subnet.instance.vpc_id}"
}

variable "db_size_gb" {
  description = "Disk size of the RDS instance to create"
  default     = "80"
}

variable "db_instance_class" {
  default = "db.m4.large"
}

variable "db_name" {
  description = "Name of the Postgres database. Set this blank on the first run if you are restoring using a snapshot_identifier. Subsequent runs should let it take its default value."
  default     = "atlas_production"
}

// Multi AZ allows database snapshots to be taken without incurring an I/O
// penalty on the  primary node. This should be `true` for production workloads.
variable "db_multi_az" {
  description = "Multi-AZ sets up a second database instance for perforance and availability"
  default     = true
}

variable "db_snapshot_identifier" {
  description = "Snapshot of database to use upon creation of RDS"
  default     = ""
}

variable "bucket_force_destroy" {
  description = "Control if terraform should destroy the S3 bucket even if there are contents. This wil destroy any backups."
  default     = false
}

variable "kms_key_id" {
  description = "A KMS Key to use rather than having a new one created"
  default     = ""
}

variable "archivist_sse" {
  type        = "string"
  description = "Setting for server-side encryption of objects in S3; if provided, must be set to 'aws:kms'"
  default     = ""
}

variable "archivist_kms_key_id" {
  type        = "string"
  description = "An optional KMS key for use by Archivist to enable S3 server-side encryption"
  default     = ""
}

variable "arn_partition" {
  description = "AWS partition to use (used mostly by govcloud)"
  default     = "aws"
}

variable "internal_elb" {
  description = "Indicates that this installation is to be accessed only by a private subnet"
  default     = false
}

variable "startup_script" {
  description = "Shell or other cloud-init compatible code to run on startup"
  default     = ""
}

variable "external_security_group_ids" {
  description = "The IDs of existing security groups to use for the ELB instead of creating one."
  type        = "list"
  default     = []
}

variable "internal_security_group_ids" {
  description = "The IDs of existing security groups to use for the instance instead of creating one."
  type        = "list"
  default     = []
}

variable "proxy_url" {
  description = "A url (http or https, with port) to proxy all external http/https request from the cluster to."
  default     = ""
}

variable "no_proxy" {
  type        = "string"
  description = "hosts to exclude from proxying (only applies when proxy_url is set)"
  default     = ""
}


variable "openvpn_sg_id" {
  description = "SG of openVPN"
}

# A random identifier to use as a suffix on resource names to prevent
# collisions when multiple instances of TFE are installed in a single AWS
# account.
resource "random_id" "installation-id" {
  byte_length = 6
}

provider "aws" {
  region = "${var.region}"
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}
