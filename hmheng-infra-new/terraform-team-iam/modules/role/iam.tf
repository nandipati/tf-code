variable "role" {}
variable "aws_region" {}
variable "core_vpc_id" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "iam" {
  statement {
    sid = "iam${replace(var.role,"-","")}"

    actions = [
      "iam:*",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/io.hmheng.${var.role}*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/io.hmheng.${var.role}*",
    ]
  }
}

resource "aws_iam_policy" "iam" {
  name   = "terraform_${var.role}_iam"
  policy = "${data.aws_iam_policy_document.iam.json}"
}

resource "aws_iam_user_policy_attachment" "terraform_iam" {
  user       = "${aws_iam_user.terraform_user.name}"
  policy_arn = "${aws_iam_policy.iam.arn}"
}

data "aws_iam_policy_document" "global" {
  statement {
    sid = "GlobalPermissions${replace(var.role,"-","")}"

    actions = [
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSecurityGroupReferences",
      "ec2:DescribeStaleSecurityGroups",
      "ec2:DescribeVpcs",
      "rds:DescribeDBCluster",
      "rds:DescribeDBClusters",
      "rds:DescribeDBInstances",
      "iam:GetRole",
      "kms:DescribeKey",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:ListResourceTags",
      "kms:ListAliases",
      "kms:CreateKey",
      "kms:CreateAlias",
      "kms:PutKeyPolicy",
      "kms:DeleteAlias",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DescribeNetworkInterfaces",
      "s3:CreateBucket",
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "s3:ListBucketVersions",
      "elasticache:Create*",
      "elasticache:AddTagsToResource",
      "elasticache:DescribeCacheClusters",
      "sqs:CreateQueue",
      "sqs:ListQueues",
      "sqs:TagQueue",
      "kinesis:CreateStream",
      "route53:GetHostedZone",
      "route53:ChangeResourceRecordSets",
      "route53:GetChange",
      "route53:ListResourceRecordSets",
      "lambda:CreateFunction",
      "lambda:GetFunction",
      "lambda:CreateEventSourceMapping",
      "lambda:GetEventSourceMapping",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "global" {
  name   = "terraform_${var.role}_global"
  policy = "${data.aws_iam_policy_document.global.json}"
}

resource "aws_iam_user_policy_attachment" "terraform_global" {
  user       = "${aws_iam_user.terraform_user.name}"
  policy_arn = "${aws_iam_policy.global.arn}"
}

data "aws_iam_policy_document" "sg" {
  statement {
    sid = "Sg${replace(var.role,"-","")}"

    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:DeleteSecurityGroup",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/Name"

      values = [
        "hmheng-${var.role}*",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "ec2:Vpc"

      values = [
        "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:vpc/${var.core_vpc_id}",
      ]
    }
  }
}

resource "aws_iam_policy" "sg" {
  name   = "terraform_${var.role}_sg"
  policy = "${data.aws_iam_policy_document.sg.json}"
}

resource "aws_iam_user_policy_attachment" "terraform_sg" {
  user       = "${aws_iam_user.terraform_user.name}"
  policy_arn = "${aws_iam_policy.sg.arn}"
}

data "aws_iam_policy_document" "rdsCreate" {
  statement {
    sid = "RdsCreate${replace(var.role,"-","")}"

    actions = [
      "rds:CreateDBCluster",
      "rds:Create*",
    ]

    resources = [
      "arn:aws:rds:${var.aws_region}:${data.aws_caller_identity.current.account_id}:subgrp:brcore01_service",
    ]
  }
}

resource "aws_iam_policy" "rdsCreate" {
  name   = "terraform_${var.role}_rds_create"
  policy = "${data.aws_iam_policy_document.rdsCreate.json}"
}

resource "aws_iam_user_policy_attachment" "rdsCreate" {
  user       = "${aws_iam_user.terraform_user.name}"
  policy_arn = "${aws_iam_policy.rdsCreate.arn}"
}

data "aws_iam_policy_document" "fullControlOfTeamsDb" {
  statement {
    sid = "AllRds${replace(var.role,"-","")}"

    actions = [
      "rds:*",
    ]

    resources = [
      "arn:aws:rds:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster:hmheng-${var.role}*",
      "arn:aws:rds:${var.aws_region}:${data.aws_caller_identity.current.account_id}:db:hmheng-${var.role}*",
      "arn:aws:rds:${var.aws_region}:${data.aws_caller_identity.current.account_id}:pg:hmheng-${var.role}*",
    ]
  }
}

resource "aws_iam_policy" "fullControlOfTeamsDb" {
  name   = "terraform_${var.role}_rds_full_team"
  policy = "${data.aws_iam_policy_document.fullControlOfTeamsDb.json}"
}

resource "aws_iam_user_policy_attachment" "fullControlOfTeamsDb" {
  user       = "${aws_iam_user.terraform_user.name}"
  policy_arn = "${aws_iam_policy.fullControlOfTeamsDb.arn}"
}

##### SQS ######
data "aws_iam_policy_document" "fullControlOfTeamsSqs" {
  statement {
    sid = "AllSqs${replace(var.role,"-","")}"

    actions = [
      "sqs:*",
    ]

    resources = [
      "arn:aws:sqs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:io-hmheng-${var.role}",
    ]
  }
}

resource "aws_iam_policy" "fullControlOfTeamsSqs" {
  name   = "terraform_${var.role}_sqs_full_team"
  policy = "${data.aws_iam_policy_document.fullControlOfTeamsSqs.json}"
}

resource "aws_iam_user_policy_attachment" "fullControlOfTeamsSqs" {
  user       = "${aws_iam_user.terraform_user.name}"
  policy_arn = "${aws_iam_policy.fullControlOfTeamsSqs.arn}"
}

##### S3 #####
data "aws_iam_policy_document" "fullControlOfTeamsS3" {
  statement {
    sid = "AllS3${replace(var.role,"-","")}"

    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::hmheng-${var.role}",
      "arn:aws:s3:::hmheng-${var.role}/*",
    ]
  }
}

resource "aws_iam_policy" "fullControlOfTeamsS3" {
  name   = "terraform_${var.role}_s3_full_team"
  policy = "${data.aws_iam_policy_document.fullControlOfTeamsS3.json}"
}

resource "aws_iam_user_policy_attachment" "fullControlOfTeamsS3" {
  user       = "${aws_iam_user.terraform_user.name}"
  policy_arn = "${aws_iam_policy.fullControlOfTeamsS3.arn}"
}

data "aws_iam_policy_document" "fullControlOfKinesis" {
  statement {
    sid = "AllKinesis${replace(var.role,"-","")}"

    actions = [
      "kinesis:*",
    ]

    resources = [
      "arn:aws:kinesis:${var.aws_region}:${data.aws_caller_identity.current.account_id}:stream/io.hmheng.${var.role}*",
    ]
  }
}

resource "aws_iam_policy" "fullControlOfTeamskinesis" {
  name   = "terraform_${var.role}_kinesis_full_team"
  policy = "${data.aws_iam_policy_document.fullControlOfKinesis.json}"
}

resource "aws_iam_user_policy_attachment" "fullControlOfTeamskinesis" {
  user       = "${aws_iam_user.terraform_user.name}"
  policy_arn = "${aws_iam_policy.fullControlOfTeamskinesis.arn}"
}

data "aws_iam_policy_document" "fullControlOfTeamsCache" {
  statement {
    sid = "AllCache${replace(var.role,"-","")}"

    actions = [
      "elasticache:*",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/cost"

      values = [
        "${var.role}*",
      ]
    }
  }

  statement {
    sid = "AllLambda${replace(var.role,"-","")}"

    actions = [
      "lambda:*",
    ]

    resources = [
      "arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:hmheng-${var.role}*",
    ]
  }
}

resource "aws_iam_policy" "fullControlOfTeamsCache" {
  name   = "terraform_${var.role}_elasticache_full_team"
  policy = "${data.aws_iam_policy_document.fullControlOfTeamsCache.json}"
}

resource "aws_iam_user_policy_attachment" "fullControlOfTeamsCache" {
  user       = "${aws_iam_user.terraform_user.name}"
  policy_arn = "${aws_iam_policy.fullControlOfTeamsCache.arn}"
}
