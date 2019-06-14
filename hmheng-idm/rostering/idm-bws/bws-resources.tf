############# Queues #############

resource "aws_sqs_queue" "idm-bws-sqs-notification" {
  name                       = "io-hmheng-idm-${var.tag_stage}-bws-notification"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds  = "${var.message_retention_seconds}"
  max_message_size           = "${var.max_message_size}"
  delay_seconds              = "${var.delay_seconds}"
  receive_wait_time_seconds  = "${var.receive_wait_time_seconds}"

  redrive_policy = <<EOF
{
    "maxReceiveCount": ${var.message_retry_count},
    "deadLetterTargetArn": "${aws_sqs_queue.idm-bws-sqs-notification-dlq.arn}"
}
EOF
}

resource "aws_sqs_queue" "idm-bws-sqs-notification-dlq" {
  name = "io-hmheng-idm-${var.tag_stage}-bws-notification-dlq"
}

resource "aws_sqs_queue" "idm-bws-sqs-cleanup" {
  name                       = "io-hmheng-idm-${var.tag_stage}-bws-cleanup"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds  = "${var.message_retention_seconds}"
  max_message_size           = "${var.max_message_size}"
  delay_seconds              = "${var.delay_seconds}"
  receive_wait_time_seconds  = "${var.receive_wait_time_seconds}"

  redrive_policy = <<EOF
{
    "maxReceiveCount": ${var.message_retry_count},
    "deadLetterTargetArn": "${aws_sqs_queue.idm-bws-sqs-cleanup-dlq.arn}"
}
EOF
}

resource "aws_sqs_queue" "idm-bws-sqs-cleanup-dlq" {
  name = "io-hmheng-idm-${var.tag_stage}-bws-cleanup-dlq"
}

#####################################

############# IAM Roles #############

data "aws_iam_policy_document" "idm-bws-sqs-policy" {
  statement {
    actions = ["sqs:*"]

    resources = [
      "${aws_sqs_queue.idm-bws-sqs-notification.arn}",
      "${aws_sqs_queue.idm-bws-sqs-cleanup.arn}",
    ]
  }
}

resource "aws_iam_policy" "idm-bws-policy" {
  name        = "io.hmheng.idm.${var.tag_stage}.bws.local"
  path        = "/"
  description = "IDM BWS ${var.tag_stage} Policy"
  policy      = "${data.aws_iam_policy_document.idm-bws-sqs-policy.json}"
}

resource "aws_iam_policy_attachment" "idm-bws" {
  name = "io.hmheng.idm.${var.tag_stage}.bws"

  roles = [
    "${aws_iam_role.idm-bws-role.name}",
  ]

  policy_arn = "${aws_iam_policy.idm-bws-policy.arn}"
}

data "aws_iam_policy_document" "idm-bws-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::711638685743:root"]
    }
  }
}

resource "aws_iam_role" "idm-bws-role" {
  name               = "io.hmheng.idm.${var.tag_stage}.bws.local"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.idm-bws-assume-role-policy.json}"
}

#####################################

