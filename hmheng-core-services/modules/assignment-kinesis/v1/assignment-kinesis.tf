resource "aws_iam_role_policy" "hmheng-core-services-kinesis-policy" {
  name = "io.hmheng-core-services.${var.tag_stage}.assignment.kinesis.local"
  role = "${aws_iam_role.hmheng-core-services-kinesis-role.id}"
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
        "${aws_kinesis_stream.hmheng-core-services-hmhone-assessment-status.arn}"
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

resource "aws_iam_role" "hmheng-core-services-kinesis-role" {
  name = "io.hmheng.core-services.${var.tag_stage}.assignment.kinesis.local"
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

resource "aws_kinesis_stream" "hmheng-core-services-hmhone-assessment-status" {
  name = "io.hmheng.core-services.${var.tag_stage}.kinesis.hmhone.asessment.status"
  shard_count = "${var.shard_count}"
  retention_period = "${var.retention_period}"
  tags {
    Stage = "${var.tag_stage}"
    Environment = "${var.tag_environment}"
    Project = "${var.tag_project}"
    cost = "${var.tag_cost}"
  }
}