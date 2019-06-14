############# IAM Role Policy for IDS Import Worker#############

data "aws_iam_policy_document" "idm-ids-import-worker-sqs-policy" {
  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:DeleteMessageBatch",
      "sqs:ChangeMessageVisibility",
      "sqs:ChangeMessageVisibilityBatch",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
    ]

    resources = [
      "arn:aws:sqs:us-east-1:711638685743:io_hmheng_idm_${var.tag_stage}_ids_fp-import-notification",
    ]
  }
}

resource "aws_iam_policy" "idm-ids-import-worker-policy" {
  name        = "io.hmheng.idm.${var.tag_stage}.ids.import.worker.local"
  path        = "/"
  description = "IDM IDS Import Worker ${var.tag_stage} Policy"
  policy      = "${data.aws_iam_policy_document.idm-ids-import-worker-sqs-policy.json}"
}

resource "aws_iam_policy_attachment" "idm-ids-import-worker" {
  name = "io.hmheng.idm.${var.tag_stage}.ids.import.worker"

  roles = [
    "${aws_iam_role.idm-ids-import-worker-role.name}",
  ]

  policy_arn = "${aws_iam_policy.idm-ids-import-worker-policy.arn}"
}

data "aws_iam_policy_document" "idm-ids-import-worker-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::711638685743:root"]
    }
  }
}

resource "aws_iam_role" "idm-ids-import-worker-role" {
  name               = "io.hmheng.idm.${var.tag_stage}.ids.import.worker.local"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.idm-ids-import-worker-assume-role-policy.json}"
}

##############################################################################################

############# IAM Role Policy for SUS Import Worker#############

data "aws_iam_policy_document" "idm-sus-import-worker-sqs-policy" {
  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:DeleteMessageBatch",
      "sqs:ChangeMessageVisibility",
      "sqs:ChangeMessageVisibilityBatch",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
    ]

    resources = [
      "arn:aws:sqs:us-east-1:711638685743:idma_${var.tag_stage}_sus_import_notification",
    ]
  }
}

resource "aws_iam_policy" "idm-sus-import-worker-policy" {
  name        = "io.hmheng.idm.${var.tag_stage}.sus.import.worker.local"
  path        = "/"
  description = "IDM SUS Import Worker ${var.tag_stage} Policy"
  policy      = "${data.aws_iam_policy_document.idm-sus-import-worker-sqs-policy.json}"
}

resource "aws_iam_policy_attachment" "idm-sus-import-worker" {
  name = "io.hmheng.idm.${var.tag_stage}.sus.import.worker"

  roles = [
    "${aws_iam_role.idm-sus-import-worker-role.name}",
  ]

  policy_arn = "${aws_iam_policy.idm-sus-import-worker-policy.arn}"
}

data "aws_iam_policy_document" "idm-sus-import-worker-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::711638685743:root"]
    }
  }
}

resource "aws_iam_role" "idm-sus-import-worker-role" {
  name               = "io.hmheng.idm.${var.tag_stage}.sus.import.worker.local"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.idm-sus-import-worker-assume-role-policy.json}"
}

##############################################################################################

