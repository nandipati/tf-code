resource "aws_iam_role" "report-config-server" {
    name = "io.hmheng.report.${var.tag_stage}.config.local"
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

resource "aws_kms_key" "report-config-server" {
    description = "This key provides encryption for Reporting and Scoring spring config server ${var.tag_stage}."
    key_usage = "ENCRYPT_DECRYPT"
    deletion_window_in_days = 30
    is_enabled = true
    enable_key_rotation = false
    policy = <<EOF
{
      "Version": "2012-10-17",
      "Id": "key-default-1",
      "Statement": [
        {
          "Sid": "allow_iam_to_assign_permissions_via_policy__required",
          "Effect": "Allow",
          "Principal": {"AWS": "arn:aws:iam::${var.br_aws_account_number}:root"},
          "Action": "kms:*",
          "Resource": "*"
        },
        {
          "Sid": "allow_hmheng-report_config-server_key_usage",
          "Effect": "Allow",
          "Principal": {"AWS": [
            "${aws_iam_role.report-config-server.arn}"
          ]},
          "Action": [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*"
          ],
          "Resource": "*"
        }
      ]
}
EOF
}

resource "aws_kms_alias" "report-config-server" {
    name = "alias/io-hmheng-report-${var.tag_stage}-config-server"
    target_key_id = "${aws_kms_key.report-config-server.key_id}"
}
