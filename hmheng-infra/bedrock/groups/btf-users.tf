resource "aws_iam_group" "btf-users" {
  name = "btf-users"
  path = "/"
}

resource "aws_iam_group_policy" "btf-users" {
  name = "btf-users-policy"
  group  = "${aws_iam_group.btf-users.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeToken",
      "Resource": [
        "arn:aws:iam::${var.account_number}:role/brnpa-btf",
        "arn:aws:iam::${var.account_number}:role/brnpb-btf",
        "arn:aws:iam::${var.account_number}:role/brcore01_jenkins_build",
        "arn:aws:iam::${var.account_number}:role/brcoredev_jenkins_build"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group_membership" "btf-users" {
  name  = "btf-users-members"
  users = "${var.infra_team}"
  group = "${aws_iam_group.btf-users.name}"
}
