resource "aws_iam_role" "core-services-config-server" {
  name = "io.hmheng.core-services.${var.tag_stage}.config.local"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.br_aws_account_number}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_kms_key" "core-services-config-server" {
  description = "This key provides encryption for core-services spring config server ${var.tag_stage}."
  depends_on = ["aws_iam_role.core-services-config-server"]
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
          "Sid": "allow_hmheng-core-services_config-server_key_usage",
          "Effect": "Allow",
          "Principal": {"AWS": [
            "${aws_iam_role.core-services-config-server.arn}"
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

resource "aws_kms_alias" "core-services-config-server" {
  name = "alias/io-hmheng-core-services-${var.tag_stage}-config-server"
  target_key_id = "${aws_kms_key.core-services-config-server.key_id}"
}
