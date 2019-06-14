data "aws_iam_policy_document" "terraform_enterprise_tags" {
  statement {
    sid = "ResourceLevelPermissionsTagsCreate"

    actions = [
      "ec2:CreateTags",
    ]

    resources = [
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:dhcp-options/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:internet-gateway/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:network-acl/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:route-table/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:security-group/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:subnet/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:vpc/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:vpn-gateway/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:vpc-peering-connection/*",
    ]

    condition {
      test = "StringEquals"

      values = [
        "${var.environment}${var.deployment_group}",
      ]

      variable = "aws:RequestTag/environment"
    }
  }

  statement {
    sid = "ResourceLevelPermissionsTagsDelete"

    actions = [
      "ec2:DeleteTags",
    ]

    resources = [
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:dhcp-options/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:internet-gateway/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:network-acl/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:route-table/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:security-group/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:subnet/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:vpc/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:vpn-gateway/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:vpc-peering-connection/*",
    ]

    condition {
      test = "StringNotEquals"

      values = [
        "${var.environment}${var.deployment_group}",
      ]

      variable = "aws:Resource/environment"
    }
  }

  statement {
    sid = "ResourceLevelPermissionsTagsCreateNonEnv"

    actions = [
      "ec2:CreateTags",
    ]

    resources = [
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:dhcp-options/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:internet-gateway/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:network-acl/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:route-table/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:security-group/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:subnet/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:vpc/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:vpn-gateway/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:vpc-peering-connection/*",
    ]

    condition {
      test = "StringNotEquals"

      values = [
        "${var.environment}${var.deployment_group}",
      ]

      variable = "aws:RequestTag/environment"
    }
  }
}

resource "aws_iam_policy" "terraform_enterprise_tags" {
  name   = "terraform_${var.environment}${var.deployment_group}_${var.stack_name}_tags"
  policy = "${data.aws_iam_policy_document.terraform_enterprise_tags.json}"
}

resource "aws_iam_user_policy_attachment" "terraform_enterprise_tags" {
  user       = "${aws_iam_user.terraform_enterprise.name}"
  policy_arn = "${aws_iam_policy.terraform_enterprise_tags.arn}"
}
