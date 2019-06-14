resource "aws_iam_role_policy" "idm-sus-sqs-crossaccount" {
    name = "io.hmheng.idm.${var.tag_stage}.sus.sqs.crossaccount"
    role = "${aws_iam_role.idm-sus-sqs-crossaccount.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:SendMessage",
        "sqs:GetQueueAttributes"
      ],
      "Effect": "Allow",
      "Resource": "${aws_sqs_queue.idm-sus-sqs.arn}"
    }
  ]
}
EOF
}
resource "aws_iam_role" "idm-sus-sqs-crossaccount" {
    name = "io.hmheng.idm.${var.tag_stage}.sus.sqs.crossaccount"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${lookup(var.vpc_dub, var.tag_stage)}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "idm-sus-sqs-local" {
    name = "io.hmheng.idm.${var.tag_stage}.sus.sqs.local"
    role = "${aws_iam_role.idm-sus-sqs-local.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:SendMessage",
        "sqs:GetQueueAttributes",
        "sqs:PurgeQueue"
      ],
      "Effect": "Allow",
      "Resource": "${aws_sqs_queue.idm-sus-sqs.arn}"
    }
  ]
}
EOF
}
resource "aws_iam_role" "idm-sus-sqs-local" {
    name = "io.hmheng.idm.${var.tag_stage}.sus.sqs.local"
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

resource "aws_iam_role_policy" "idm-sus-dlq-sqs-local" {
    name = "io.hmheng.idm.${var.tag_stage}.sus.dlq.sqs.local"
    role = "${aws_iam_role.idm-sus-dlq-sqs-local.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:SendMessage",
        "sqs:GetQueueAttributes",
        "sqs:PurgeQueue"
      ],
      "Effect": "Allow",
      "Resource": "${aws_sqs_queue.idm-sus-sqs-dlq.arn}"
    }
  ]
}
EOF
}
resource "aws_iam_role" "idm-sus-dlq-sqs-local" {
    name = "io.hmheng.idm.${var.tag_stage}.sus.dlq.sqs.local"
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

resource "aws_sqs_queue" "idm-sus-sqs" {
  name = "idma_${var.tag_stage}_sus_import_notification"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds = "${var.message_retention_seconds}"
  max_message_size = "${var.max_message_size}"
  delay_seconds = "${var.delay_seconds}"
  receive_wait_time_seconds = "${var.receive_wait_time_seconds}"
  redrive_policy = <<EOF
{
    "maxReceiveCount": 3,
    "deadLetterTargetArn": "${aws_sqs_queue.idm-sus-sqs-dlq.arn}"
}
EOF
}

resource "aws_sqs_queue" "idm-sus-sqs-dlq" {
  name = "idma_${var.tag_stage}_sus_import_notification_dlq"
}