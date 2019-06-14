resource "aws_iam_role_policy" "idm-ids-sqs-reindex" {
    name = "io.hmheng.idm.${var.tag_stage}.ids.reindex.sqs.local"
    role = "${aws_iam_role.idm-ids-sqs-reindex.id}"
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
      "Resource": "${aws_sqs_queue.idm-ids-sqs-reindex.arn}"
    }
  ]
}
EOF
}
resource "aws_iam_role" "idm-ids-sqs-reindex" {
    name = "io.hmheng.idm.${var.tag_stage}.ids.sqs.reindex.local"
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


resource "aws_sqs_queue" "idm-ids-sqs-reindex" {
  name = "io_hmheng_idm_${var.tag_stage}_ids_reindex"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds = "${var.message_retention_seconds}"
  max_message_size = "${var.max_message_size}"
  delay_seconds = "${var.delay_seconds}"
  receive_wait_time_seconds = "${var.receive_wait_time_seconds}"
}