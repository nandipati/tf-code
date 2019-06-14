resource "aws_iam_role_policy" "hmheng-report-kinesis-policy" {
    name = "io.hmheng.ed.${var.tag_stage}.report.kinesis.local"
    role = "${aws_iam_role.ed-report-role.id}"
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
        "${aws_kinesis_stream.ed-usercontent-report-stream.arn}",
        "arn:aws:kinesis:us-east-1:711638685743:stream/io_hmheng_hmhone_${var.tag_stage}_assessment_score_itemdata_stream"
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
        "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.ed-usercontent-report-kinesis.checkpoint",
        "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.hmhone-score-itemdata-learnosity-application"
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
resource "aws_iam_role" "ed-report-role" {
    name = "io.hmheng.ed.${var.tag_stage}.report.kinesis.local"
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
resource "aws_kinesis_stream" "ed-usercontent-report-stream" {
    name = "io_hmheng_ed_${var.tag_stage}_usercontent-report-stream"
    shard_count = "${lookup(var.shard_count,var.tag_stage)}"
    retention_period = "${var.retention_period}"
    tags {
        Stage = "${var.tag_stage}"
        Environment = "${var.tag_environment}"
        Project = "${var.tag_project}"
        cost = "${var.tag_cost}"
    }
}
resource "aws_iam_role_policy" "ed-aggregator-dataservices-kinesis-crossaccount" {
    name = "io.hmheng.ed.${var.tag_stage}.aggregator.dataservices.kinesis.crossaccount"
    role = "${aws_iam_role.ed-aggregator-dataservices-kinesis-crossaccount.id}"
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
        "${aws_kinesis_stream.ed-usercontent-report-stream.arn}",
        "arn:aws:kinesis:us-east-1:711638685743:stream/io_hmheng_hmhone_${var.tag_stage}_assessment_score_itemdata_stream"
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
        "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.ed-usercontent-report-kinesis.checkpoint",
        "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.hmhone-score-itemdata-learnosity-application"
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

resource "aws_iam_role" "ed-aggregator-dataservices-kinesis-crossaccount" {
    name = "io.hmheng.ed.${var.tag_stage}.aggregator.dataservices.kinesis.crossaccount"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
        "arn:aws:iam::187631879586:root"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}