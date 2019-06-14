resource "aws_sns_topic" "obo-generatePDF-sns" {
  name = "io_hmheng_${var.aurora_role}_${var.stage}_${var.service_name}_generatePDF"
}

resource "aws_sns_topic" "obo-sftpNotification-sns" {
  name = "io_hmheng_${var.aurora_role}_${var.stage}_${var.service_name}_sftpNotification"
}

data "aws_iam_policy_document" "sns-iam-role-policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.br_aws_account_number}:root"]
    }
  }
}

resource "aws_iam_role" "sns-iam-role" {
  name               = "${var.service_name}-iam-sns-role-${var.stage}"
  path               = "/${var.service_name}/"
  assume_role_policy = "${data.aws_iam_policy_document.sns-iam-role-policy.json}"
}

data "aws_iam_policy_document" "sns-publish-subscribe-role" {
  statement {
    effect = "Allow"

    actions = ["sns:Publish",
      "sns:Subscribe",
      "sns:ConfirmSubscription",
      "sns:Unsubscribe",
      "sns:ListTopics",
    ]

    resources = ["${aws_sns_topic.obo-generatePDF-sns.arn}",
      "${aws_sns_topic.obo-sftpNotification-sns.arn}",
    ]
  }
}

resource "aws_iam_role_policy" "sns-iam-policy" {
  name   = "sns-role-publish-notifications"
  role   = "${aws_iam_role.sns-iam-role.id}"
  policy = "${data.aws_iam_policy_document.sns-publish-subscribe-role.json}"
}
