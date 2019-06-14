resource "aws_iam_role_policy" "isg-sqs-crossaccount" {
    name = "com.hmhco.isg.${var.tag_stage}.isg.sqs.crossaccount"
    role = "${aws_iam_role.isg-pcs-sqs-crossaccount.id}"
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
      "Resource": [
      "${aws_sqs_queue.ProdCtrlsRequestTopicQueue.arn}",
      "${aws_sqs_queue.TlspAppProdCtrlsResponseTopicQueue.arn}"
      ]
    }
  ]
}
EOF
}
resource "aws_iam_role" "isg-pcs-sqs-crossaccount" {
    name = "com.hmhco.isg.${var.tag_stage}.isg.sqs.crossaccount"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::431353658782:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "isg-pcs-sqs" {
    name = "com.hmhco.isg.${var.tag_stage}.pcs.sqs.local"
    role = "${aws_iam_role.isg-pcs-sqs.id}"
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
        "sqs:SendMessage"
      ],
      "Effect": "Allow",
      "Resource": [
      "${aws_sqs_queue.ProdCtrlsRequestTopicQueue.arn}",
      "${aws_sqs_queue.TlspAppProdCtrlsResponseTopicQueue.arn}"
      ]
    }
  ]
}
EOF
}
resource "aws_iam_role" "isg-pcs-sqs" {
    name = "com.hmhco.isg.${var.tag_stage}.pcs.sqs.local"
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


resource "aws_sqs_queue" "ProdCtrlsRequestTopicQueue" {
  name = "com-hmhco-isg-${var.tag_stage}-pcs-ProdCtrlsRequestTopicQueue"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds = "${var.message_retention_seconds}"
  max_message_size = "${var.max_message_size}"
  delay_seconds = "${var.delay_seconds}"
  receive_wait_time_seconds = "${var.receive_wait_time_seconds}"
}

resource "aws_sqs_queue" "TlspAppProdCtrlsResponseTopicQueue" {
  name = "com-hmhco-isg-${var.tag_stage}-pcs-TlspAppProdCtrlsResponseTopicQueue"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds = "${var.message_retention_seconds}"
  max_message_size = "${var.max_message_size}"
  delay_seconds = "${var.delay_seconds}"
  receive_wait_time_seconds = "${var.receive_wait_time_seconds}"
}
