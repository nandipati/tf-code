resource "aws_s3_bucket" "clm" {
    bucket = "hmheng-clm"
    region = "us-east-1"
    acl    = "private"

    lifecycle_rule {
        id      = "backup-expiration"
        prefix  = "neo4j/"
        enabled = true

        expiration {
          days = 365
        }
    }

    tags {
        cost = "${var.tag_cost}"
        responsible-party = "${var.tag_responsible_party}"
    }

}

resource "aws_s3_bucket_object" "neo4j" {
    bucket = "${aws_s3_bucket.clm.id}"
    acl    = "private"
    key    = "neo4j/${var.tag_stage}/"
    source = "/dev/null"
}

data "aws_iam_policy_document" "s3-policy" {
  statement {
    actions = [
    "s3:*",
  ]
  resources = [
    "arn:aws:s3:::hmheng-clm/neo4j/${var.tag_stage}",
    "arn:aws:s3:::hmheng-clm/neo4j/${var.tag_stage}/*"
  ]
  }
}

resource "aws_iam_policy" "clm-neo4j-policy" {
    name   = "io.hmheng.clm.${var.tag_stage}.neo4j.s3.local"
    path   = "/"
    description = "clm ${var.tag_stage} s3 policy"
    policy = "${data.aws_iam_policy_document.s3-policy.json}"
}

resource "aws_iam_policy_attachment" "clm-s3" {
    name  = "clm_${var.tag_stage}_s3"
    roles = [
      "${aws_iam_role.clm-neo4j-role.name}",
      "${aws_iam_role.clm-neo4j-backup-crossaccount.name}"
    ]
    policy_arn = "${aws_iam_policy.clm-neo4j-policy.arn}"
}

data "aws_iam_policy_document" "clm_assumerole" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::711638685743:root"]
    }
  }
}

data "aws_iam_policy_document" "clm_assumerole_cross" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${lookup(var.dub_acct_id, var.tag_stage)}:root"]
    }
  }
}

resource "aws_iam_role" "clm-neo4j-role" {
    name               = "io.hmheng.clm.${var.tag_stage}.neo4j.s3.local"
    assume_role_policy = "${data.aws_iam_policy_document.clm_assumerole.json}"
}

resource "aws_iam_role" "clm-neo4j-backup-crossaccount" {
  name               = "io.hmheng.clm.${var.tag_stage}.neo4j-backup.crossaccount"
  assume_role_policy = "${data.aws_iam_policy_document.clm_assumerole_cross.json}"
}