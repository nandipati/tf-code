############# Queues #############

resource "aws_sqs_queue" "idm-ais-sqs-notification" {
  name                       = "io-hmheng-idm-${var.tag_stage}-ais-notification"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds  = "${var.message_retention_seconds}"
  max_message_size           = "${var.max_message_size}"
  delay_seconds              = "${var.delay_seconds}"
  receive_wait_time_seconds  = "${var.receive_wait_time_seconds}"

  redrive_policy = <<EOF
{
    "maxReceiveCount": ${var.message_retry_count},
    "deadLetterTargetArn": "${aws_sqs_queue.idm-ais-sqs-notification-dlq.arn}"
}  
EOF
}

resource "aws_sqs_queue" "idm-ais-sqs-notification-dlq" {
  name                       = "io-hmheng-idm-${var.tag_stage}-ais-notification-dlq"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds  = "${var.message_retention_seconds}"
  max_message_size           = "${var.max_message_size}"
  delay_seconds              = "${var.delay_seconds}"
  receive_wait_time_seconds  = "${var.receive_wait_time_seconds}"
}

############# IAM Role/Cross Account Policy for Bedrock ais#############

data "aws_iam_policy_document" "idm-ais-sqs-policy" {
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
      "${aws_sqs_queue.idm-ais-sqs-notification.arn}",
    ]
  }
}

resource "aws_iam_policy" "idm-ais-policy" {
  name        = "io.hmheng.idm.${var.tag_stage}.ais.local"
  path        = "/"
  description = "IDM AIS ${var.tag_stage} Policy"
  policy      = "${data.aws_iam_policy_document.idm-ais-sqs-policy.json}"
}

resource "aws_iam_policy_attachment" "idm-ais" {
  name = "io.hmheng.idm.${var.tag_stage}.ais"

  roles = [
    "${aws_iam_role.idm-ais-role.name}",
  ]

  policy_arn = "${aws_iam_policy.idm-ais-policy.arn}"
}

data "aws_iam_policy_document" "idm-ais-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::711638685743:root"]
    }
  }
}

resource "aws_iam_role" "idm-ais-role" {
  name               = "io.hmheng.idm.${var.tag_stage}.ais.local"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.idm-ais-assume-role-policy.json}"
}

###########################IAM/Cross Account Policy for Dublin EBR ##################################

data "aws_iam_policy_document" "idm-old-ebr-sqs-policy-crossaccount" {
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
      "${aws_sqs_queue.idm-ais-sqs-notification.arn}",
    ]
  }
}

resource "aws_iam_policy" "idm-old-ebr-policy-crossaccount" {
  name        = "io.hmheng.idm.${var.tag_stage}.old.ebr.crossaccount"
  path        = "/"
  description = "IDM Dublin VPC EBR ${var.tag_stage} Policy"
  policy      = "${data.aws_iam_policy_document.idm-old-ebr-sqs-policy-crossaccount.json}"
}

resource "aws_iam_policy_attachment" "idm-old-ebr-crossaccount" {
  name = "io.hmheng.idm.${var.tag_stage}.old.ebr"

  roles = [
    "${aws_iam_role.idm-old-ebr-role-crossaccount.name}",
  ]

  policy_arn = "${aws_iam_policy.idm-old-ebr-policy-crossaccount.arn}"
}

data "aws_iam_policy_document" "idm-old-ebr-assume-role-policy-crossaccount" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${lookup(var.vpc_dub, var.tag_stage)}:root"]
    }
  }
}

resource "aws_iam_role" "idm-old-ebr-role-crossaccount" {
  name               = "io.hmheng.idm.${var.tag_stage}.old.ebr.crossaccount"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.idm-old-ebr-assume-role-policy-crossaccount.json}"
}

####################################################################
### S3 bucket access

resource "aws_iam_role" "idm-ais-iam-role" {
  name               = "io.hmheng-idm-${var.tag_stage}-ais.local"
  path               = "/${var.tag_stage}/imports/api/"
  assume_role_policy = "${data.aws_iam_policy_document.idm-ais-assume-role-policy.json}"
}

data "aws_iam_policy_document" "idm-ais-role-policy-document" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]

    resources = ["arn:aws:s3:::hmheng_idm, arn:aws:s3:::hmheng_idm/*"]
  }
}

resource "aws_iam_role_policy" "idm-ais-iam-role-policy" {
  name   = "io-hmheng-idm-${var.tag_stage}-ais-policy"
  role   = "${aws_iam_role.idm-ais-iam-role.id}"
  policy = "${data.aws_iam_policy_document.idm-ais-role-policy-document.json}"
}

#############Access to SP Import Queue#############
######FP Write to the SP Importer Queue##########

data "aws_iam_policy_document" "idm-ais-sp-importer-sqs-policy" {
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

resource "aws_iam_policy" "idm-ais-sp-importer-notification-policy" {
  name        = "io.hmheng.idm.${var.tag_stage}.ais.sp.importer.local"
  path        = "/"
  description = "IDM FP to SP Importer ${var.tag_stage} Policy"
  policy      = "${data.aws_iam_policy_document.idm-ais-sp-importer-sqs-policy.json}"
}

resource "aws_iam_policy_attachment" "idm-fp-sp-importer-policy-attachment" {
  name = "io.hmheng.idm.${var.tag_stage}.sp.importer.export"

  roles = [
    "${aws_iam_role.idm-ais-role.name}",
  ]

  policy_arn = "${aws_iam_policy.idm-ais-sp-importer-notification-policy.arn}"
}
