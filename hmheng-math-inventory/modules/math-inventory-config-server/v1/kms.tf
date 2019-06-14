resource "aws_iam_role" "math-inventory-config-server" {
  name = "io.hmheng.math-inventory.${var.stage}.config.local"

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

resource "aws_kms_key" "math-inventory-config-server" {
  description             = "This key provides encryption for math-inventory spring config server ${var.stage}."
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = false

  policy = <<EOF
{
      "Version": "2012-10-17",
      "Id": "key-default-1",
      "Statement": [
        {
          "Sid": "allow_iam_to_assign_permissions_via_policy__required",
          "Effect": "Allow",
          "Principal": {"AWS": [
              "arn:aws:iam::${var.br_aws_account_number}:user/terraform-enterprise/terraform-math-inventory",
              "arn:aws:iam::${var.br_aws_account_number}:root"
          ]},
          "Action": "kms:*",
          "Resource": "*"
        },
        {
          "Sid": "allow_hmheng-math-inventory_config-server_key_usage",
          "Effect": "Allow",
          "Principal": {"AWS": [
            "${aws_iam_role.math-inventory-config-server.arn}"
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

resource "aws_kms_alias" "math-inventory-config-server" {
  name          = "alias/io-hmheng-math-inventory-${var.stage}-config-server"
  target_key_id = "${aws_kms_key.math-inventory-config-server.key_id}"
}
