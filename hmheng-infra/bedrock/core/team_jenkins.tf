resource "aws_iam_user" "jenkins" {
  count = "${var.jenkins_prod}"
  name  = "bedrock_jenkins"
}

resource "aws_iam_access_key" "jenkins" {
  count = "${var.jenkins_prod}"
  user  = "${aws_iam_user.jenkins.name}"
}

resource "aws_iam_user_policy" "jenkins_ec2" {
  count  = "${var.jenkins_prod}"
  name   = "jenkins_ec2_access"
  user   = "${aws_iam_user.jenkins.name}"
  policy = "${data.aws_iam_policy_document.bedrock_jenkins_ec2.json}"
}

resource "aws_s3_bucket" "jenkins_key_bucket" {
  count  = "${var.jenkins_prod}"
  bucket = "bedrock_jenkins_keys"
  acl    = "private"
  policy = "${data.aws_iam_policy_document.bedrock_jenkins_bucket.json}"
}

data "aws_iam_policy_document" "bedrock_jenkins_ec2" {
  statement {
    actions = [
      "ec2:DescribeSpotInstanceRequests",
      "ec2:CancelSpotInstanceRequests",
      "ec2:GetConsoleOutput",
      "ec2:RequestSpotInstances",
      "ec2:RunInstances",
      "ec2:StartInstances",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DescribeInstances",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeRegions",
      "ec2:DescribeImages",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "iam:PassRole",
    ]

    resources = ["*"]
  }

  statement {
    actions = ["ec2:RunInstances"]
    effect  = "Deny"

    condition {
      test     = "StringNotEquals"
      variable = "ec2:InstanceType"
      values   = ["t2.micro", "t2.small", "t2.medium", "t2.large", "t2.xlarge"]
    }

    resources = ["arn:aws:ec2:*:${var.br_aws_account_number}:instance/*"]
  }

  statement {
    actions = [
      "ec2:StopInstances",
      "ec2:TerminateInstances",
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/Name"
      values   = ["jenkins-build-slave-spot"]
    }

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "bedrock_jenkins_bucket" {
  statement {
    sid     = "DenyIncorrectEncryptionHeader"
    actions = ["s3:PutObject"]
    effect  = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = ["arn:aws:s3:::bedrock_jenkins_keys/*"]

    condition = {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }
  }

  statement {
    sid     = "DenyUnEncryptedObjectUploads"
    actions = ["s3:PutObject"]
    effect  = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = ["arn:aws:s3:::bedrock_jenkins_keys/*"]

    condition = {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }
  }
}

output "aws_iam_access_id" {
  value = "${aws_iam_access_key.jenkins.*.id}"
}

output "aws_iam_secret_access_key" {
  value = "${aws_iam_access_key.jenkins.*.secret}"
}
