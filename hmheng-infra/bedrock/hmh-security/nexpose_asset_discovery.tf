data "aws_iam_policy_document" "nexpose_asset_discovery_assumerole" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.hmh_security_aws_account_number}:root"]
    }
  }
}

resource "aws_iam_role" "nexpose_asset_discovery" {
  name               = "${var.environment}.nexpose.asset-discovery.ca"
  assume_role_policy = "${data.aws_iam_policy_document.nexpose_asset_discovery_assumerole.json}"
}

data "aws_iam_policy_document" "nexpose_asset_discovery" {
  statement = [
    {
      sid = "NexposeDiscoveryCloudTrail20180321"

      actions = [
        "cloudtrail:LookupEvents",
        "cloudtrail:DescribeTrails",
      ]

      resources = [
        "*",
      ]
    },
    {
      sid = "HMHNexposeDiscovery"

      actions = [
        "ec2:DescribeInstances",
        "ec2:DescribeImages",
        "ec2:DescribeAddresses",
      ]

      resources = [
        "*",
      ]
    },
  ]
}

resource "aws_iam_policy" "asset_discovery" {
  name   = "${var.environment}.nexpose.asset-discovery.ca"
  path   = "/"
  policy = "${data.aws_iam_policy_document.nexpose_asset_discovery.json}"
}

resource "aws_iam_role_policy_attachment" "asset_discovery" {
  role       = "${aws_iam_role.nexpose_asset_discovery.name}"
  policy_arn = "${aws_iam_policy.asset_discovery.arn}"
}
