resource "aws_kms_key" "key" {
  count       = "${var.kms_key_id != "" ? 0 : 1}"
  description = "TFE resource encryption key"

  tags {
    Name = "terraform_enterprise-${random_id.installation-id.hex}"
  }

  # This references the role created by the instance module as a name
  # rather than a resource attribute because it causes too much churn.
  # So if the name is changed in the instance module, you need to change
  # the name here too.
  policy = <<-JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow KMS for TFE creator",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${data.aws_caller_identity.current.arn}",
          "arn:${var.arn_partition}:iam::${data.aws_caller_identity.current.account_id}:root",
          "arn:${var.arn_partition}:iam::${data.aws_caller_identity.current.account_id}:role/tfe_iam_role-${random_id.installation-id.hex}"
        ]
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
  JSON
}

resource "aws_kms_alias" "key" {
  name          = "alias/terraform_enterprise-${random_id.installation-id.hex}"
  target_key_id = "${coalesce(var.kms_key_id, join("", aws_kms_key.key.*.key_id))}"
}

module "route53" {
  source         = "modules/tfe-route53"
  hostname       = "${var.hostname}"
  zone_id        = "${var.zone_id}"
  alias_dns_name = "${module.instance.dns_name}"
  alias_zone_id  = "${module.instance.zone_id}"
}

module "instance" {
  source                      = "modules/tfe-instance"
  installation_id             = "${random_id.installation-id.hex}"
  ami_id                      = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  hostname                    = "${var.fqdn}"
  vpc_id                      = "${data.aws_subnet.instance.vpc_id}"
  cert_id                     = "${data.aws_acm_certificate.terraform.arn}"
  instance_subnet_id          = "${var.instance_subnet_id}"
  elb_subnet_id               = "${var.elb_subnet_id}"
  key_name                    = "${var.key_name}"
  db_username                 = "${var.local_db ? "atlasuser" : var.db_username}"
  db_password                 = "${var.local_db ? "databasepassword" : var.db_password}"
  db_endpoint                 = "${var.local_db ? "127.0.0.1:5432" : module.db.endpoint}"
  db_database                 = "${var.local_db ? "atlas_production" : module.db.database}"
  redis_host                  = "${var.local_redis ? "127.0.0.1" : module.redis.host}"
  redis_port                  = "${var.local_redis ? "6379" : module.redis.port}"
  bucket_name                 = "${var.bucket_name}"
  bucket_region               = "${var.region}"
  kms_key_id                  = "${coalesce(var.kms_key_id, join("", aws_kms_key.key.*.arn))}"
  archivist_sse               = "${var.archivist_sse}"
  archivist_kms_key_id        = "${var.archivist_kms_key_id}"
  bucket_force_destroy        = "${var.bucket_force_destroy}"
  manage_bucket               = "${var.manage_bucket}"
  arn_partition               = "${var.arn_partition}"
  internal_elb                = "${var.internal_elb}"
  ebs_redundancy              = "${(var.local_redis || var.local_db) ? var.ebs_redundancy : 0}"
  startup_script              = "${var.startup_script}"
  external_security_group_ids = "${var.external_security_group_ids}"
  external_security_group_cidrs = "${var.external_security_group_cidrs}"

  internal_security_group_ids = "${var.internal_security_group_ids}"
  proxy_url                   = "${var.proxy_url}"
  no_proxy                    = "${var.no_proxy}"
  local_setup                 = "${var.local_setup}"
  openvpn_sg_id               = "${var.openvpn_sg_id}"
}

module "db" {
  source                  = "modules/rds"
  disable                 = "${var.local_db}"
  instance_class          = "${var.db_instance_class}"
  multi_az                = "${var.db_multi_az}"
  name                    = "tfe-${random_id.installation-id.hex}"
  username                = "${var.db_username}"
  password                = "${var.db_password}"
  storage_gbs             = "${var.db_size_gb}"
  subnet_ids              = "${var.data_subnet_ids}"
  engine_version          = "9.4"
  vpc_cidr                = "${data.aws_vpc.vpc.cidr_block}"
  vpc_id                  = "${data.aws_subnet.instance.vpc_id}"
  backup_retention_period = "31"
  storage_type            = "gp2"
  kms_key_id              = "${coalesce(var.kms_key_id, join("", aws_kms_key.key.*.arn))}"
  snapshot_identifier     = "${var.db_snapshot_identifier}"
  db_name                 = "${var.db_name}"
  instance_sg_id          = "${join(",",module.instance.instance_sg_id)}"
}

module "redis" {
  source        = "modules/redis"
  disable       = "${var.local_redis}"
  name          = "tfe-${random_id.installation-id.hex}"
  subnet_ids    = "${var.data_subnet_ids}"
  vpc_cidr      = "${data.aws_vpc.vpc.cidr_block}"
  vpc_id        = "${data.aws_subnet.instance.vpc_id}"
  instance_type = "cache.m3.medium"
}

output "kms_key_id" {
  value = "${coalesce(var.kms_key_id, join("", aws_kms_key.key.*.arn))}"
}

output "url" {
  value = "https://${var.fqdn}"
}

output "dns_name" {
  value = "${module.instance.dns_name}"
}

output "zone_id" {
  value = "${module.instance.zone_id}"
}

output "iam_role" {
  value = "${module.instance.iam_role}"
}
