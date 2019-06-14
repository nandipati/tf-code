data "aws_iam_policy_document" "terraform_enterprise_s3" {
  statement {
    sid = "s3Global"

    actions = [
      "s3:CreateBucket",
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    sid = "s3Restricted"

    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${var.environment}${var.deployment_group}-logs",
    ]
  }
}

resource "aws_iam_policy" "terraform_enterprise_s3" {
  name   = "terraform_${var.environment}${var.deployment_group}_${var.stack_name}_s3"
  policy = "${data.aws_iam_policy_document.terraform_enterprise_s3.json}"
}

resource "aws_iam_user_policy_attachment" "terraform_enterprise_s3" {
  user       = "${aws_iam_user.terraform_enterprise.name}"
  policy_arn = "${aws_iam_policy.terraform_enterprise_s3.arn}"
}
