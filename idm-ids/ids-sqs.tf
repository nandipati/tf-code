resource "aws_iam_role_policy" "idm-ids-sqs-crossaccount" {
    name = "io.hmheng.idm.${var.tag_stage}.ids.sqs.crossaccount"
    role = "${aws_iam_role.idm-ids-sqs-crossaccount.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:SendMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ],
      "Effect": "Allow",
      "Resource": "${aws_sqs_queue.idm-ids-sqs.arn}"
    }
  ]
}
EOF
}
resource "aws_iam_role" "idm-ids-sqs-crossaccount" {
    name = "io.hmheng.idm.${var.tag_stage}.ids.sqs.crossaccount"
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

resource "aws_iam_role_policy" "idm-ids-sqs" {
    name = "io.hmheng.idm.${var.tag_stage}.ids.sqs.local"
    role = "${aws_iam_role.idm-ids-sqs.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:AddPermission",
        "sqs:DeleteMessage",
        "sqs:ChangeMessageVisibility",
        "sqs:GetQueueAttributes",
        "sqs:ReceiveMessage",
        "sqs:SendMessage",
        "sqs:PurgeQueue"
      ],
      "Effect": "Allow",
      "Resource": "${aws_sqs_queue.idm-ids-sqs.arn}"
    }
  ]
}
EOF
}
resource "aws_iam_role" "idm-ids-sqs" {
    name = "io.hmheng.idm.${var.tag_stage}.ids.sqs.local"
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


resource "aws_sqs_queue" "idm-ids-sqs" {
  name = "io_hmheng_idm_${var.tag_stage}_ids_fp-import-notification"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds = "${var.message_retention_seconds}"
  max_message_size = "${var.max_message_size}"
  delay_seconds = "${var.delay_seconds}"
  receive_wait_time_seconds = "${var.receive_wait_time_seconds}"
}

############# EBR - IDS & SUS POLICIES #############

data "aws_iam_policy_document" "idm-ebr-sqs-policy" {
  statement {
    actions = [
        "sqs:DeleteMessage",
        "sqs:ChangeMessageVisibility",
        "sqs:GetQueueAttributes",
        "sqs:ReceiveMessage",
        "sqs:SendMessage",
        "sqs:PurgeQueue"
      ]
    
    resources = [
      "${aws_sqs_queue.idm-ids-sqs.arn}",
      "arn:aws:sqs:us-east-1:711638685743:idma_${var.tag_stage}_sus_import_notification"
    ]
  }
}

resource "aws_iam_policy" "idm-ebr-policy" {
  name        = "io.hmheng.idm.${var.tag_stage}.ebr.local"
  path        = "/"
  description = "IDM EBR ${var.tag_stage} Policy"
  policy      = "${data.aws_iam_policy_document.idm-ebr-sqs-policy.json}"
}

resource "aws_iam_policy_attachment" "idm-ebr-attachment" {
  name = "io.hmheng.idm.${var.tag_stage}.ebr"

  roles = [
    "${aws_iam_role.idm-ebr-role.name}",
  ]

  policy_arn = "${aws_iam_policy.idm-ebr-policy.arn}"
}

data "aws_iam_policy_document" "idm-ebr-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::711638685743:root"]
    }
  }
}

resource "aws_iam_role" "idm-ebr-role" {
  name               = "io.hmheng.idm.${var.tag_stage}.ebr.local"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.idm-ebr-assume-role-policy.json}"
}

#################################################