resource "aws_s3_bucket" "core_terraform_bucket" {
  bucket = "${var.core_vpc_abbrev}-terraform"
  acl    = "private"

  tags {
    Name        = "${var.core_vpc_abbrev}-terraform"
    environment = "${var.core_vpc_abbrev}"
    stage       = "prod"
    cost        = "${var.tag_cost}"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "vault_consul_backup" {
  bucket = "${var.consul_bucket_name}"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags {
    Name        = "${var.core_vpc_abbrev}-consul"
    environment = "${var.core_vpc_abbrev}"
    cost        = "${var.tag_cost}"
  }
}

resource "aws_s3_bucket" "artifactory_bucket" {
  bucket        = "${var.artifactory_bucket_name}"
  acl           = "private"
  force_destroy = false

  versioning {
    enabled = false
  }

  tags {
    cost = "artifactory"
  }
}

resource "aws_s3_bucket" "certificate_authority" {
  bucket = "${var.combined_env_abbrev}-ca"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags {
    Name        = "${var.combined_env_abbrev}.ca"
    environment = "${var.combined_env_abbrev}"
    cost        = "${var.tag_cost}"
  }
}

output "aws_s3_bucket_ca" {
  value = "${aws_s3_bucket.certificate_authority.arn}"
}
