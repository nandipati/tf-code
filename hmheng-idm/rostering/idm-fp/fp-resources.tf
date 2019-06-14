############# Queues #############

resource "aws_sqs_queue" "idm-fp-sqs-notification" {
  name                       = "io-hmheng-idm-${var.tag_stage}-fp-notification"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds  = "${var.message_retention_seconds}"
  max_message_size           = "${var.max_message_size}"
  delay_seconds              = "${var.delay_seconds}"
  receive_wait_time_seconds  = "${var.receive_wait_time_seconds}"

  redrive_policy = <<EOF
{
    "maxReceiveCount": ${var.message_retry_count},
    "deadLetterTargetArn": "${aws_sqs_queue.idm-fp-sqs-notification-dlq.arn}"
}  
EOF
}

resource "aws_sqs_queue" "idm-fp-sqs-notification-dlq" {
  name                       = "io-hmheng-idm-${var.tag_stage}-fp-notification-dlq"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds  = "${var.message_retention_seconds}"
  max_message_size           = "${var.max_message_size}"
  delay_seconds              = "${var.delay_seconds}"
  receive_wait_time_seconds  = "${var.receive_wait_time_seconds}"
}

############# IAM Role/Cross Account Policy for Bedrock FP#############

data "aws_iam_policy_document" "idm-fp-sqs-policy" {
  statement {
    actions = [
      "sqs:SendMessage",
      "sqs:SendMessageBatch",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:DeleteMessageBatch",
      "sqs:ChangeMessageVisibility",
      "sqs:ChangeMessageVisibilityBatch",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
    ]

    resources = [
      "${aws_sqs_queue.idm-fp-sqs-notification.arn}",
    ]
  }
}

resource "aws_iam_policy" "idm-fp-policy" {
  name        = "io.hmheng.idm.${var.tag_stage}.fp.local"
  path        = "/"
  description = "IDM fp ${var.tag_stage} Policy"
  policy      = "${data.aws_iam_policy_document.idm-fp-sqs-policy.json}"
}

resource "aws_iam_policy_attachment" "idm-fp" {
  name = "io.hmheng.idm.${var.tag_stage}.fp"

  roles = [
    "${aws_iam_role.idm-fp-role.name}",
  ]

  policy_arn = "${aws_iam_policy.idm-fp-policy.arn}"
}

data "aws_iam_policy_document" "idm-fp-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::711638685743:root"]
    }
  }
}

resource "aws_iam_role" "idm-fp-role" {
  name               = "io.hmheng.idm.${var.tag_stage}.fp.local"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.idm-fp-assume-role-policy.json}"
}

###########################IAM/Cross Account Policy for Dublin FP ##################################

data "aws_iam_policy_document" "idm-old-fp-sqs-policy-crossaccount" {
  statement {
    actions = [
      "sqs:SendMessage",
      "sqs:SendMessageBatch",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:DeleteMessageBatch",
      "sqs:ChangeMessageVisibility",
      "sqs:ChangeMessageVisibilityBatch",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
    ]

    resources = [
      "${aws_sqs_queue.idm-fp-sqs-notification.arn}",
    ]
  }
}

resource "aws_iam_policy" "idm-old-fp-policy-crossaccount" {
  name        = "io.hmheng.idm.${var.tag_stage}.old.fp.crossaccount"
  path        = "/"
  description = "IDM Dublin VPC FP ${var.tag_stage} Policy"
  policy      = "${data.aws_iam_policy_document.idm-old-fp-sqs-policy-crossaccount.json}"
}

resource "aws_iam_policy_attachment" "idm-old-fp-crossaccount" {
  name = "io.hmheng.idm.${var.tag_stage}.old.fp"

  roles = [
    "${aws_iam_role.idm-old-fp-role-crossaccount.name}",
  ]

  policy_arn = "${aws_iam_policy.idm-old-fp-policy-crossaccount.arn}"
}

data "aws_iam_policy_document" "idm-old-fp-assume-role-policy-crossaccount" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${lookup(var.vpc_dub, var.tag_stage)}:root"]
    }
  }
}

resource "aws_iam_role" "idm-old-fp-role-crossaccount" {
  name               = "io.hmheng.idm.${var.tag_stage}.old.fp.crossaccount"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.idm-old-fp-assume-role-policy-crossaccount.json}"
}

#######################################################################

######FP Write to the SP Importer Queue##########

data "aws_iam_policy_document" "idm-fp-sp-importer-sqs-policy" {
  statement {
    actions = [
      "sqs:SendMessage",
      "sqs:SendMessageBatch",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
    ]

    resources = [
      "arn:aws:sqs:us-east-1:711638685743:io-hmheng-idm-${var.tag_stage}-sp-importer-notification",
    ]
  }
}

resource "aws_iam_policy" "idm-fp-sp-importer-notification-policy" {
  name        = "io.hmheng.idm.${var.tag_stage}.fp.sp.importer.local"
  path        = "/"
  description = "IDM FP to SP Importer ${var.tag_stage} Policy"
  policy      = "${data.aws_iam_policy_document.idm-fp-sp-importer-sqs-policy.json}"
}

resource "aws_iam_policy_attachment" "idm-fp-sp-importer-policy-attachment" {
  name = "io.hmheng.idm.${var.tag_stage}.sp.importer.export"

  roles = [
    "${aws_iam_role.idm-fp-role.name}",
  ]

  policy_arn = "${aws_iam_policy.idm-fp-sp-importer-notification-policy.arn}"
}
