resource "aws_iam_role_policy" "ds-isgservice-kinesis-policy" {
    name = "io.hmheng.ds.${var.tag_stage}.ds.kinesis.local"
    role = "${aws_iam_role.ds-isgservice-role.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
           "kinesis:DescribeStream",
           "kinesis:GetShardIterator",
           "kinesis:GetRecords",
           "kinesis:ListStreams",
           "kinesis:MergeShards",
           "kinesis:PutRecord",
           "kinesis:PutRecords",
           "kinesis:SplitShard"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_kinesis_stream.ds_isgservice_caliper_stream.arn}"
      ]
    },{
      "Action": [
          "dynamodb:CreateTable",
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:PutMetricData",
          "dynamodb:Scan",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
      ],
      "Effect": "Allow",
      "Resource": [
          "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.ds-isgservice-kinesis.checkpoint"
      ]
    },
    {
      "Action" : [
        "cloudwatch:PutMetricData"
      ],
      "Effect": "Allow",
      "Resource" : ["*"]
    }
  ]
}
EOF
}
resource "aws_iam_role" "ds-isgservice-role" {
    name = "io.hmheng.ds.${var.tag_stage}.ds.kinesis.local"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::711638685743:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_kinesis_stream" "ds_isgservice_caliper_stream" {
    name = "io_hmheng_ds_${var.tag_stage}_isgservice_caliper_stream"
    shard_count = "${lookup(var.shard_count,var.tag_stage)}"
    retention_period = "${var.retention_period}"
    tags {
        Stage = "${var.tag_stage}"
        Environment = "${var.tag_environment}"
        cost = "${var.tag_cost}"
        Cost-center = "${var.tag_cost_center}"
        Responsible-party = "${var.tag_responsible_party}"
    }
}




resource "aws_iam_role_policy" "ds-isgservice-kinesis-crossaccount-policy" {
    name = "io.hmheng.ds.${var.tag_stage}.ds.kinesis.crossaccount"
    role = "${aws_iam_role.ds-isgservice-crossaccount-role.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
           "kinesis:DescribeStream",
           "kinesis:ListStreams",
           "kinesis:PutRecord",
           "kinesis:PutRecords"
      ],
      "Effect": "Allow",
      "Resource": "${aws_kinesis_stream.ds_isgservice_caliper_stream.arn}"
    }
  ]
}
EOF
}


resource "aws_iam_role" "ds-isgservice-crossaccount-role" {
    name = "io.hmheng.ds.${var.tag_stage}.ds.kinesis.crossaccount"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${lookup(var.isg_acct_id, var.tag_stage)}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}