resource "aws_kinesis_stream" "ds_hmhcentral_caliper_stream" {
  name             = "io_hmheng_ds_${var.tag_stage}_hmhcentral_caliper_stream"
  shard_count      = "${lookup(var.shard_count,var.tag_stage)}"
  retention_period = "${var.retention_period}"

  tags {
    Stage             = "${var.tag_stage}"
    cost              = "${var.tag_cost}"
    Cost-center       = "${var.tag_cost_center}"
    Responsible-party = "${var.tag_responsible_party}"
  }
}

data "aws_iam_policy_document" "hmhcentral-kinesis-policy" {
  statement {
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListStreams",
      "kinesis:MergeShards",
      "kinesis:PutRecord",
      "kinesis:PutRecords",
      "kinesis:SplitShard",
    ]

    resources = [
      "${aws_kinesis_stream.ds_hmhcentral_caliper_stream.arn}",
    ]
  }

  statement {
    actions = [
      "dynamodb:CreateTable",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:PutMetricData",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
    ]

    resources = [
      "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.ds-hmhcentral-kinesis.checkpoint",
    ]
  }

  statement {
    actions = [
      "cloudwatch:PutMetricData",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "hmhcentral-assumerole-policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::711638685743:root"]
    }
  }
}

data "aws_iam_policy_document" "hmhcentral-kinesis-crossaccount-policy" {
  statement {
    actions = [
      "kinesis:DescribeStream",
      "kinesis:ListStreams",
      "kinesis:PutRecord",
      "kinesis:PutRecords",
    ]

    resources = [
      "${aws_kinesis_stream.ds_hmhcentral_caliper_stream.arn}",
    ]
  }
}

data "aws_iam_policy_document" "hmhcentral-crossaccount-assumerole-policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${lookup(var.hmhcentral_aws_acc_ids, var.tag_stage)}:root"]
    }
  }
}

resource "aws_iam_role" "ds-hmhcentral-role" {
  name               = "io.hmheng.ds.${var.tag_stage}.hmhc.kinesis.local"
  assume_role_policy = "${data.aws_iam_policy_document.hmhcentral-assumerole-policy.json}"
}

resource "aws_iam_role_policy" "ds-hmhcentral-kinesis-role-policy" {
  name   = "io.hmheng.ds.${var.tag_stage}.hmhc.kinesis.local"
  role   = "${aws_iam_role.ds-hmhcentral-role.id}"
  policy = "${data.aws_iam_policy_document.hmhcentral-kinesis-policy.json}"
}

resource "aws_iam_role" "ds-hmhcentral-crossaccount-role" {
  name               = "io.hmheng.ds.${var.tag_stage}.hmhc.kinesis.crossaccount"
  assume_role_policy = "${data.aws_iam_policy_document.hmhcentral-crossaccount-assumerole-policy.json}"
}

resource "aws_iam_role_policy" "ds-hmhcentral-kinesis-crossaccount-role-policy" {
  name   = "io.hmheng.ds.${var.tag_stage}.hmhc.kinesis.crossaccount"
  role   = "${aws_iam_role.ds-hmhcentral-crossaccount-role.id}"
  policy = "${data.aws_iam_policy_document.hmhcentral-kinesis-crossaccount-policy.json}"
}
