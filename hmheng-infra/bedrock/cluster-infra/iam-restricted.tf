data "aws_iam_policy_document" "terraform_enterprise_restricted" {
  statement {
    sid = "ResourceLevelPermissionsEnvCond"

    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:DeleteDhcpOptions",
      "ec2:DeleteInternetGateway",
      "ec2:DeleteNetworkAcl",
      "ec2:DeleteRoute",
      "ec2:DeleteRouteTable",
      "ec2:DeleteVpcPeeringConnection",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
    ]

    resources = [
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:vpc/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:security-group/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:dhcp-options/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:internet-gateway/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:network-acl/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:route-table/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:vpc-peering-connection/*",
      "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:security-group/*",
    ]

    condition {
      test = "StringEquals"

      values = [
        "${var.environment}${var.deployment_group}",
      ]

      variable = "ec2:ResourceTag/environment"
    }
  }
}

resource "aws_iam_policy" "terraform_enterprise_restricted" {
  name   = "terraform_${var.environment}${var.deployment_group}_${var.stack_name}_restricted"
  policy = "${data.aws_iam_policy_document.terraform_enterprise_restricted.json}"
}

resource "aws_iam_user_policy_attachment" "terraform_enterprise_restricted" {
  user       = "${aws_iam_user.terraform_enterprise.name}"
  policy_arn = "${aws_iam_policy.terraform_enterprise_restricted.arn}"
}
