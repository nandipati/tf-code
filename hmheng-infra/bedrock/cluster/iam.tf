resource "aws_iam_role" "btf" {
  name = "${var.vpc_abbrev}-btf"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${var.account_number}:root",
          "${var.brnpb_jenkins_slave_role_arn}"
        ],
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ec2" {
  name   = "${var.vpc_abbrev}-btf-ec2"
  path   = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
       "Sid": "GlobalPermissions",
       "Effect": "Allow",
       "Action": [
         "ec2:Create*",
         "ec2:Associate*",
         "ec2:Disassociate*",
         "ec2:Modify*",
         "ec2:Replace*",
         "ec2:AllocateAddress",
         "ec2:ReleaseAddress",
         "ec2:AttachNetworkInterface",
         "ec2:DetachNetworkInterface",
         "ec2:DeleteNetworkInterface",
         "ec2:AttachInternetGateway",
         "ec2:AttachVpnGateway",
         "ec2:MonitorInstances",
         "ec2:UnmonitorInstances",
         "ec2:AssignPrivateIpAddresses",
         "ec2:UnassignPrivateIpAddresses",
         "ec2:DeleteTags",
         "ec2:DeleteSubnet",
         "ec2:DeleteNatGateways",
         "iam:CreatePolicy",
         "iam:CreateRole",
         "iam:DetachRolePolicy"
       ],
       "Resource": "*"
     },
     {
       "Sid": "AllowProperlyTagged",
       "Effect": "Allow",
       "Action": [
         "ec2:DeleteSecurityGroup",
         "ec2:DeleteVolume",
         "ec2:DeleteRoute",
         "ec2:DeleteRouteTable",
         "ec2:DeleteNetworkAcl",
         "ec2:DeleteNetworkAclEntry",
         "ec2:DeleteInternetGateway",
         "ec2:DeleteDhcpOptions",
         "ec2:AuthorizeSecurityGroupEgress",
         "ec2:AuthorizeSecurityGroupIngress",
         "ec2:RevokeSecurityGroupEgress",
         "ec2:RevokeSecurityGroupIngress",
         "ec2:AttachVolume",
         "ec2:DetachVolume",
         "ec2:TerminateInstances",
         "ec2:StopInstances",
         "ec2:StartInstances",
         "ec2:RebootInstances",
         "ec2:GetConsoleScreenshot"
       ],
       "Resource": "*",
       "Condition": {
         "StringEquals": {
           "ec2:ResourceTag/environment": "${var.vpc_abbrev}"
         }
       }
     },
     {
       "Sid": "RunInstanceOwnVpc",
       "Effect": "Allow",
       "Action": "ec2:RunInstances",
       "Resource": [
         "arn:aws:ec2:${var.vpc_region}:${var.account_number}:subnet/*",
         "arn:aws:ec2:${var.vpc_region}:${var.account_number}:network-interface/*"
       ],
       "Condition": {
         "StringEquals": {
           "ec2:vpc": "arn:aws:ec2:${var.vpc_region}:${var.account_number}:vpc/${var.vpc_id}"
         }
       }
     },
     {
       "Sid": "RunInstanceOwnSecurityGroup",
       "Effect": "Allow",
       "Action": "ec2:RunInstances",
       "Resource": [
         "arn:aws:ec2:${var.vpc_region}:${var.account_number}:security-group/${var.vpc_abbrev}*"
       ]
     },
     {
       "Sid": "RunInstanceStandardKeypair",
       "Effect": "Allow",
       "Action": "ec2:RunInstances",
       "Resource": [
         "arn:aws:ec2:${var.vpc_region}:${var.account_number}:key-pair/${var.key_pair}"
       ]
     },
     {
       "Sid": "RunInstanceAnyResource",
       "Effect": "Allow",
       "Action": "ec2:RunInstances",
       "Resource": [
         "arn:aws:ec2:${var.vpc_region}:${var.account_number}:instance/*",
         "arn:aws:ec2:${var.vpc_region}:${var.account_number}:volume/*",
         "arn:aws:ec2:${var.vpc_region}::image/*",
         "arn:aws:ec2:${var.vpc_region}::snapshot/*",
         "arn:aws:ec2:${var.vpc_region}:${var.account_number}:placement-group/*"
       ]
     },
     {
         "Sid": "S3FullAccessToSpecificCoreBuckets",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::platform-terraform-assets",
                "arn:aws:s3:::platform-terraform-assets/*"
            ]

      },
      {
         "Sid": "IamManageExistingRoles",
            "Effect": "Allow",
            "Action": [
                "iam:*"
            ],
            "Resource": [
                "arn:aws:iam::${var.account_number}:role/${var.vpc_abbrev}*",
                "arn:aws:iam::${var.account_number}:policy/${var.vpc_abbrev}*"
            ]
      },
      {
         "Sid": "IamManageExistingPolicies",
            "Effect": "Allow",
            "Action": [
                "iam:CreatePolicyVersion",
                "iam:DeletePolicyVersion"
            ],
            "Resource": "arn:aws:iam::${var.account_number}:role/${var.vpc_abbrev}*"
      },
      {
         "Sid": "IamManageExistingInstanceProfiles",
            "Effect": "Allow",
            "Action": [
                "iam:GetInstanceProfile",
                "iam:DetachRolePolicy",
                "iam:CreateInstanceProfile",
                "iam:AddRoleToInstanceProfile",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:DeleteInstanceProfile",
                "iam:CreatePolicyVersion"
            ],
            "Resource": "*"
      },
      {
         "Sid": "IAMPermissionsRestricted",
         "Effect": "Allow",
         "Action": [
            "iam:passrole"
          ],
         "Resource": [
            "arn:aws:iam::${var.account_number}:role/${var.vpc_abbrev}*"
         ]
      },
      {
         "Sid": "autoscaling",
         "Effect": "Allow",
         "Action": [
            "autoscaling:*"
          ],
         "Resource": [
            "*"
         ]
      }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "btf-ec2" {
  role       = "${aws_iam_role.btf.id}"
  policy_arn = "${aws_iam_policy.ec2.arn}"
}

// Classic ELB API supports resources, but the new ALB API support only "*".
// As there is no way to differentiate between the API versions, we're just
// going to use "*".
resource "aws_iam_policy" "load-balancers" {
  name   = "${var.vpc_abbrev}-btf-load-balancers"
  path   = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ALB",
      "Effect": "Allow",
      "Action": "elasticloadbalancing:*",
      "Resource": "*"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "efs" {
  statement {
    sid = "ElasticFileSystemPolicies"
    actions = [
      "elasticfilesystem:*",
    ]
    resources = [
      "arn:aws:elasticfilesystem:${var.vpc_region}:${var.account_number}:file-system/*"
    ]
  }
}

resource "aws_iam_policy" "core_jenkins_rds_policy" {
    name = "${var.vpc_abbrev}_jenkins_rds"
    path = "/"
    description = "allows jenkins to manage rds components in ${var.vpc_abbrev} vpc"
    policy = <<EOF
{

   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "RDSCreatePermissionsRestricted",
         "Effect": "Allow",
         "Action": [
            "rds:CreateDBSubnetGroup",
            "rds:CreateDBInstance",
            "rds:DescribeDBSubnetGroups",
            "rds:DescribeDBInstances",
            "rds:ModifyDBInstance",
            "rds:ListTagsForResource",
            "rds:AddTagsToResource",
            "rds:CreateDBInstance",
            "rds:DeleteDBInstance",
            "rds:DeleteDBSubnetGroup",
            "rds:DeleteDBInstance"
          ],
         "Resource": [
            "arn:aws:rds:us-east-1:${var.account_number}:db:${var.vpc_id}*",
            "arn:aws:rds:us-east-1:${var.account_number}:pg:default.postgres9.4",
            "arn:aws:rds:us-east-1:${var.account_number}:db:${var.vpc_id}*",
            "arn:aws:rds:us-east-1:${var.account_number}:subgrp:${var.vpc_abbrev}*",
            "arn:aws:rds:us-east-1:${var.account_number}:db:${var.vpc_abbrev}-grafana*"
         ]
      }
    ]
}
EOF
}

resource "aws_iam_policy" "efs" {
  name = "${var.vpc_abbrev}-btf-efs"
  path = "/"
  policy = "${data.aws_iam_policy_document.efs.json}"
}

resource "aws_iam_role_policy_attachment" "btf-load-balancers" {
  role       = "${aws_iam_role.btf.id}"
  policy_arn = "${aws_iam_policy.load-balancers.arn}"
}

resource "aws_iam_role_policy_attachment" "btf-route53" {
  role       = "${aws_iam_role.btf.id}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_role_policy_attachment" "btf-rds" {
  role       = "${aws_iam_role.btf.id}"
  policy_arn = "${aws_iam_policy.core_jenkins_rds_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "btf-readonly" {
  role       = "${aws_iam_role.btf.id}"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "btf-efs" {
  role       = "${aws_iam_role.btf.id}"
  policy_arn = "${aws_iam_policy.efs.arn}"
}


resource "aws_iam_user_policy_attachment" "user-btf-load-balancers" {
  user       = "${aws_iam_user.tf-cluster.name}"
  policy_arn = "${aws_iam_policy.load-balancers.arn}"
}

resource "aws_iam_user_policy_attachment" "user-btf-route53" {
  user       = "${aws_iam_user.tf-cluster.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_user_policy_attachment" "user-btf-rds" {
  user       = "${aws_iam_user.tf-cluster.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_rds_policy.arn}"
}

resource "aws_iam_user_policy_attachment" "user-btf-readonly" {
  user       = "${aws_iam_user.tf-cluster.name}"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_user_policy_attachment" "user-btf-efs" {
  user       = "${aws_iam_user.tf-cluster.name}"
  policy_arn = "${aws_iam_policy.efs.arn}"
}

resource "aws_iam_user_policy_attachment" "user-btf-ec2" {
  user       = "${aws_iam_user.tf-cluster.name}"
  policy_arn = "${aws_iam_policy.ec2.arn}"
}

resource "aws_iam_user" "tf-cluster" {
  name = "terraform-${var.vpc_abbrev}"
}
