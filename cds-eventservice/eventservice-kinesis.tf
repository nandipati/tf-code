resource "aws_iam_role_policy" "cds-eventservice-kinesis-policy" {
  name = "io.hmheng.cds.${var.tag_stage}.cds.kinesis.local"
  role = "${aws_iam_role.cds-eventservice-role.id}"

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
        "${aws_kinesis_stream.cds_eventservice_caliper_stream.arn}",
        "arn:aws:kinesis:us-east-1:711638685743:stream/io_hmheng_ed_${var.tag_stage}_usercontent-report-stream",
        "${aws_kinesis_stream.cds_eventservice_caliper_1_1_stream.arn}"
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
          "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.cds-eventservice-kinesis.checkpoint",
          "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.cds-eventservice-caliper_1_1-kinesis.checkpoint",
          "arn:aws:dynamodb:us-east-1:711638685743:table/${var.tag_stage}.ed-usercontent-report-kinesis.checkpoint"
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

resource "aws_iam_role" "cds-eventservice-role" {
  name = "io.hmheng.cds.${var.tag_stage}.cds.kinesis.local"

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

resource "aws_iam_role_policy" "cds-trusted-svc-kinesis-policy" {
  name = "io.hmheng.cds.${var.tag_stage}.cds.trusted.svc.kinesis.local"
  role = "${aws_iam_role.cds-trusted-svc-kinesis-role.id}"

  policy = "${data.aws_iam_policy_document.cds-trusted-svc-kinesis-policy-document.json}"
}

data "aws_iam_policy_document" "cds-trusted-svc-kinesis-policy-document" {
  statement {
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:PutRecord",
      "kinesis:PutRecords"
    ]

    resources = [
      "${aws_kinesis_stream.cds_eventservice_caliper_1_1_stream.arn}"
    ]
  }

  statement {
    actions = ["cloudwatch:PutMetricData"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "cds-trusted-svc-kinesis-role" {
  name = "io.hmheng.cds.${var.tag_stage}.cds.trusted.svc.kinesis.local"

  assume_role_policy = "${data.aws_iam_policy_document.cds-trusted-svc-kinesis-assume-role-policy-document.json}"
}

data "aws_iam_policy_document" "cds-trusted-svc-kinesis-assume-role-policy-document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::711638685743:root"]
    }
  }
}

resource "aws_kinesis_stream" "cds_eventservice_caliper_stream" {
  name             = "io_hmheng_cds_${var.tag_stage}_eventservice_caliper_stream"
  shard_count      = "${lookup(var.shard_count,var.tag_stage)}"
  retention_period = "${var.retention_period}"

  tags {
    Stage       = "${var.tag_stage}"
    Environment = "${var.tag_environment}"
    Project     = "${var.tag_project}"
    cost        = "${var.tag_cost}"
  }
}

resource "aws_kinesis_stream" "cds_eventservice_caliper_1_1_stream" {
  name             = "io_hmheng_cds_${var.tag_stage}_eventservice_caliper_1_1_stream"
  shard_count      = "${lookup(var.shard_count,var.tag_stage)}"
  retention_period = "${var.retention_period}"

  tags {
    Stage       = "${var.tag_stage}"
    Environment = "${var.tag_environment}"
    Project     = "${var.tag_project}"
    cost        = "${var.tag_cost}"
  }
}

# IAM role to allow Data Services event processing lambda access to the caliper
# event kinesis stream
resource "aws_iam_role" "caliper_event_stream_processing_lambda_role" {
  name = "io.hmheng.dataservices.${var.tag_stage}.dataservices.lambda.local"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

## IAM Role Policies
# Need to be able to access Kinesis caliper streams

resource "aws_iam_role_policy" "dataservice_lambda_kinesis_policy" {
  name = "io.hmheng.dataservices.${var.tag_stage}.dataservices.kinesis.local"
  role = "${aws_iam_role.caliper_event_stream_processing_lambda_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_kinesis_stream.cds_eventservice_caliper_stream.arn}",
        "arn:aws:kinesis:us-east-1:711638685743:stream/io_hmheng_ed_${var.tag_stage}_usercontent-report-stream",
        "${aws_kinesis_stream.cds_eventservice_caliper_1_1_stream.arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "cds-eventservice" {
  bucket = "hmheng-data-services"
  region = "us-east-1"
  acl    = "private"
  policy = <<EOPOLICY
{
    "Version": "2012-10-17",
    "Statement": [
      {
         "Effect": "Allow",
         "Principal": {
            "AWS": ["arn:aws:iam::${lookup(var.dub_acct_id, var.tag_stage)}:root",
                    "arn:aws:iam::${lookup(var.edanalytics_acct_id, var.tag_stage)}:root"]
         },
         "Action": [
            "s3:GetObject",
            "s3:ListBucket"
         ],
         "Resource": [
            "arn:aws:s3:::hmheng-data-services",
            "arn:aws:s3:::hmheng-data-services/*"
         ]
      }
    ]
}
EOPOLICY

  lifecycle_rule {
    id      = "pipeline-events-expiration"
    prefix  = "pipeline-events/"
    enabled = true

    expiration {
      days = 730
    }
  }

  lifecycle_rule {
    id      = "druid-segments-expiration"
    prefix  = "druid-segments/"
    enabled = true

    expiration {
      days = 730
    }
  }

  lifecycle_rule {
    id      = "backup-expiration"
    prefix  = "event-storage/"
    enabled = true

    expiration {
      days = 730
    }
  }

  lifecycle_rule {
    id      = "userevents-backup-expiration-dev"
    prefix  = "dev/userevents"
    enabled = true

    expiration {
      days = "${lookup(var.s3_data_exp, "dev")}"
    }
  }

  lifecycle_rule {
    id      = "userevents-backup-expiration-int"
    prefix  = "int/userevents"
    enabled = true

    expiration {
      days = "${lookup(var.s3_data_exp, "int")}"
    }
  }

  lifecycle_rule {
    id      = "userevents-backup-expiration-cert"
    prefix  = "cert/userevents"
    enabled = true

    expiration {
      days = "${lookup(var.s3_data_exp, "cert")}"
    }
  }

  lifecycle_rule {
    id      = "userevents-backup-expiration-prod"
    prefix  = "prod/userevents"
    enabled = true

    expiration {
      days = "${lookup(var.s3_data_exp, "prod")}"
    }
  }

  tags {
    cost = "${var.tag_cost}"
  }
}

resource "aws_s3_bucket_object" "event-storage" {
  bucket = "${aws_s3_bucket.cds-eventservice.id}"
  acl    = "private"
  key    = "event-storage/${var.tag_stage}/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "pipeline-events-bucket" {
  bucket = "${aws_s3_bucket.cds-eventservice.id}"
  acl    = "private"
  key    = "pipeline-events/${var.tag_stage}/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "druid-segments-bucket" {
  bucket = "${aws_s3_bucket.cds-eventservice.id}"
  acl    = "private"
  key    = "druid-segments/${var.tag_stage}/"
  source = "/dev/null"
}

data "aws_iam_policy_document" "s3-policy" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.cds-eventservice.arn}",
      "${aws_s3_bucket.cds-eventservice.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "s3-lambda-policy" {
  name   = "s3-lambda-access-policy-${var.tag_stage}"
  path   = "/"
  policy = "${data.aws_iam_policy_document.s3-policy.json}"
}

resource "aws_iam_role_policy_attachment" "s3-lambda-policy-attachment" {
  role       = "${aws_iam_role.caliper_event_stream_processing_lambda_role.id}"
  policy_arn = "${aws_iam_policy.s3-lambda-policy.arn}"
}

# Lambda
resource "aws_lambda_function" "data_services_caliper_event_processing_function" {
  count            = "${lookup(var.lambda_count, var.tag_stage)}"
  filename         = "lambda-func.zip"
  function_name    = "s3_put_object_${var.tag_stage}"
  role             = "${aws_iam_role.caliper_event_stream_processing_lambda_role.arn}"
  handler          = "s3_put_object.s3_put_object"
  runtime          = "python3.6"
  source_code_hash = "${base64sha256(file("lambda-func.zip"))}"
  timeout          = "120"

  environment {
    variables = {
      bucket = "${aws_s3_bucket.cds-eventservice.id}"
      stage  = "${var.tag_stage}"
    }
  }
}

resource "aws_lambda_event_source_mapping" "kinesis_lambda_event_mapping" {
  count             = "${lookup(var.lambda_count, var.tag_stage)}"
  batch_size        = 500
  event_source_arn  = "${aws_kinesis_stream.cds_eventservice_caliper_stream.arn}"
  enabled           = true
  function_name     = "${aws_lambda_function.data_services_caliper_event_processing_function.arn}"
  starting_position = "TRIM_HORIZON"
}
