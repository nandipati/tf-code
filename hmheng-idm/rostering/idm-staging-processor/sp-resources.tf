############# Queues #############

resource "aws_sqs_queue" "idm-sp-importer-notification" {
  name                       = "io-hmheng-idm-${var.tag_stage}-sp-importer-notification"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds  = "${var.message_retention_seconds}"
  max_message_size           = "${var.max_message_size}"
  delay_seconds              = "${var.delay_seconds}"
  receive_wait_time_seconds  = "${var.receive_wait_time_seconds}"
}

resource "aws_sqs_queue" "idm-sp-exporter-notification" {
  name                       = "io-hmheng-idm-${var.tag_stage}-sp-exporter-notification"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds  = "${var.message_retention_seconds}"
  max_message_size           = "${var.max_message_size}"
  delay_seconds              = "${var.delay_seconds}"
  receive_wait_time_seconds  = "${var.receive_wait_time_seconds}"
}

############# Queues do delete #############

resource "aws_sqs_queue" "idm-sp-sqs-notification" {
  name                       = "io-hmheng-idm-${var.tag_stage}-sp-notification"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds  = "${var.message_retention_seconds}"
  max_message_size           = "${var.max_message_size}"
  delay_seconds              = "${var.delay_seconds}"
  receive_wait_time_seconds  = "${var.receive_wait_time_seconds}"

  redrive_policy = <<EOF
{
    "maxReceiveCount": ${var.message_retry_count},
    "deadLetterTargetArn": "${aws_sqs_queue.idm-sp-sqs-notification-dlq.arn}"
}  
EOF
}

resource "aws_sqs_queue" "idm-sp-sqs-notification-dlq" {
  name                       = "io-hmheng-idm-${var.tag_stage}-sp-notification-dlq"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds  = "${var.message_retention_seconds}"
  max_message_size           = "${var.max_message_size}"
  delay_seconds              = "${var.delay_seconds}"
  receive_wait_time_seconds  = "${var.receive_wait_time_seconds}"
}

############# IAM Role/Cross Account Policy for Bedrock SP Importer#############

data "aws_iam_policy_document" "idm-sp-importer-sqs-policy" {
  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:DeleteMessageBatch",
      "sqs:PurgeQueue",
      "sqs:ChangeMessageVisibility",
      "sqs:ChangeMessageVisibilityBatch",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
    ]

    resources = [
      "${aws_sqs_queue.idm-sp-importer-notification.arn}",
    ]
  }
}

resource "aws_iam_policy" "idm-sp-importer-policy" {
  name        = "io.hmheng.idm.${var.tag_stage}.sp.importer.local"
  path        = "/"
  description = "IDM SP Importer ${var.tag_stage} Policy"
  policy      = "${data.aws_iam_policy_document.idm-sp-importer-sqs-policy.json}"
}

resource "aws_iam_policy_attachment" "idm-sp-importer" {
  name = "io.hmheng.idm.${var.tag_stage}.sp.importer"

  roles = [
    "${aws_iam_role.idm-sp-importer-role.name}",
  ]

  policy_arn = "${aws_iam_policy.idm-sp-importer-policy.arn}"
}

data "aws_iam_policy_document" "idm-sp-importer-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::711638685743:root"]
    }
  }
}

resource "aws_iam_role" "idm-sp-importer-role" {
  name               = "io.hmheng.idm.${var.tag_stage}.sp.importer.local"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.idm-sp-importer-assume-role-policy.json}"
}

####Policies for the SP Importer to write to the exporter queue
data "aws_iam_policy_document" "idm-sp-importer-exporter-sqs-policy" {
  statement {
    actions = [
      "sqs:SendMessage",
      "sqs:SendMessageBatch",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
    ]

    resources = [
      "${aws_sqs_queue.idm-sp-exporter-notification.arn}",
    ]
  }
}

resource "aws_iam_policy" "idm-sp-importer-export-policy" {
  name        = "io.hmheng.idm.${var.tag_stage}.sp-importer.local"
  path        = "/"
  description = "IDM SP Importer ${var.tag_stage} Export Policy"
  policy      = "${data.aws_iam_policy_document.idm-sp-importer-exporter-sqs-policy.json}"
}

resource "aws_iam_policy_attachment" "idm-sp-importer-export" {
  name = "io.hmheng.idm.${var.tag_stage}.sp.importer.export"

  roles = [
    "${aws_iam_role.idm-sp-importer-role.name}",
  ]

  policy_arn = "${aws_iam_policy.idm-sp-importer-export-policy.arn}"
}

##############################################################################################

############# IAM Role/Cross Account Policy for Bedrock SP Exporter#############

data "aws_iam_policy_document" "idm-sp-exporter-sqs-policy" {
  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:DeleteMessageBatch",
      "sqs:PurgeQueue",
      "sqs:ChangeMessageVisibility",
      "sqs:ChangeMessageVisibilityBatch",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
    ]

    resources = [
      "${aws_sqs_queue.idm-sp-exporter-notification.arn}",
    ]
  }
}

resource "aws_iam_policy" "idm-sp-exporter-policy" {
  name        = "io.hmheng.idm.${var.tag_stage}.sp-exporter.local"
  path        = "/"
  description = "IDM SP Exporter ${var.tag_stage} Policy"
  policy      = "${data.aws_iam_policy_document.idm-sp-exporter-sqs-policy.json}"
}

resource "aws_iam_policy_attachment" "idm-sp-exporter" {
  name = "io.hmheng.idm.${var.tag_stage}.sp.exporter"

  roles = [
    "${aws_iam_role.idm-sp-exporter-role.name}",
  ]

  policy_arn = "${aws_iam_policy.idm-sp-exporter-policy.arn}"
}

data "aws_iam_policy_document" "idm-sp-exporter-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::711638685743:root"]
    }
  }
}

resource "aws_iam_role" "idm-sp-exporter-role" {
  name               = "io.hmheng.idm.${var.tag_stage}.sp.exporter.local"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.idm-sp-exporter-assume-role-policy.json}"
}

##############################################################################################

############# IAM Role/Cross Account Policy for Bedrock sp to be deleted#############

data "aws_iam_policy_document" "idm-sp-sqs-policy" {
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
      "${aws_sqs_queue.idm-sp-sqs-notification.arn}",
    ]
  }
}

resource "aws_iam_policy" "idm-sp-policy" {
  name        = "io.hmheng.idm.${var.tag_stage}.sp.local"
  path        = "/"
  description = "IDM SP ${var.tag_stage} Policy"
  policy      = "${data.aws_iam_policy_document.idm-sp-sqs-policy.json}"
}

resource "aws_iam_policy_attachment" "idm-sp" {
  name = "io.hmheng.idm.${var.tag_stage}.sp"

  roles = [
    "${aws_iam_role.idm-sp-role.name}",
  ]

  policy_arn = "${aws_iam_policy.idm-sp-policy.arn}"
}

data "aws_iam_policy_document" "idm-sp-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::711638685743:root"]
    }
  }
}

resource "aws_iam_role" "idm-sp-role" {
  name               = "io.hmheng.idm.${var.tag_stage}.sp.local"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.idm-sp-assume-role-policy.json}"
}

##############################################################################################

