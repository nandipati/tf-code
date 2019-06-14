resource "aws_iam_role_policy" "hmheng-scoring-kinesis-policy" {
    name = "io.hmheng.hmhone.${var.tag_stage}.score.kinesis.local"
    role = "${aws_iam_role.hmhone-score-role.id}"
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
        "${aws_kinesis_stream.hmhone-assessment-score-stream.arn}",
        "${aws_kinesis_stream.hmhone-assessment-score-itemdata-stream.arn}",
        "${aws_kinesis_stream.ed-assesment-score-conversion-stream.arn}"
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
          "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.hmhone-score-learnosity-application",
          "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.hmhone-score-itemdata-learnosity-application",
          "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.ed-score-conversion-application",
          "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.assesment-score-report-kinesis.checkpoint"
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
resource "aws_iam_role" "hmhone-score-role" {
    name = "io.hmheng.hmhone.${var.tag_stage}.score.kinesis.local"
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
resource "aws_iam_role_policy" "hmhone-score-kinesis-crossaccount" {
    name = "io.hmheng.hmhone.${var.tag_stage}.score.kinesis.crossaccount"
    role = "${aws_iam_role.hmhone-score-kinesis-crossaccount.id}"
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
        "${aws_kinesis_stream.hmhone-assessment-score-stream.arn}",
        "${aws_kinesis_stream.hmhone-assessment-score-itemdata-stream.arn}",
        "${aws_kinesis_stream.ed-assesment-score-conversion-stream.arn}",
        "arn:aws:kinesis:us-east-1:711638685743:stream/io.hmheng.${var.tag_stage}.kinesis.hmhone.asessment.status"
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
          "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.hmhone-score-learnosity-application",
          "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.hmhone-score-itemdata-learnosity-application",
          "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.ed-score-conversion-application",
          "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.assesment-score-report-kinesis.checkpoint"
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
resource "aws_iam_role" "hmhone-score-kinesis-crossaccount" {
    name = "io.hmheng.hmhone.${var.tag_stage}.score.kinesis.crossaccount"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
        "arn:aws:iam::${lookup(var.vpc_learnosity, var.tag_learnosity_acc1)}:root",
        "arn:aws:iam::${lookup(var.vpc_learnosity, var.tag_learnosity_acc2)}:root",
        "arn:aws:iam::${lookup(var.vpc_learnosity, var.tag_learnosity_acc3)}:root",
        "arn:aws:iam::187631879586:root"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_kinesis_stream" "hmhone-assessment-score-stream" {
    name = "io_hmheng_hmhone_${var.tag_stage}_assessment_score_stream"
    shard_count = "${var.shard_count}"
    retention_period = "${var.retention_period}"
    tags {
        Stage = "${var.tag_stage}"
        Environment = "${var.tag_environment}"
        Project = "${var.tag_project}"
    }
}
resource "aws_kinesis_stream" "hmhone-assessment-score-itemdata-stream" {
    name = "io_hmheng_hmhone_${var.tag_stage}_assessment_score_itemdata_stream"
    shard_count = "${var.shard_count}"
    retention_period = "${var.retention_period}"
    tags {
        Stage = "${var.tag_stage}"
        Environment = "${var.tag_environment}"
        Project = "${var.tag_project}"
        cost = "${var.tag_cost}"
    }
}
resource "aws_kinesis_stream" "ed-assesment-score-conversion-stream" {
    name = "io_hmheng_ed_${var.tag_stage}_assessment_score_conversion_stream"
    shard_count = "${var.shard_count}"
    retention_period = "${var.retention_period}"
    tags {
        Stage = "${var.tag_stage}"
        Environment = "${var.tag_environment}"
        Project = "${var.tag_project}"
        cost = "${var.tag_cost}"
    }
}
