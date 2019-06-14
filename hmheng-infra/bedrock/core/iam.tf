# core vpc - jenkins build policy

resource "aws_iam_role" "core_jenkins_build_role" {
  name = "${var.core_vpc_abbrev}_jenkins_build"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${var.br_aws_account_number}:root",
          "${data.terraform_remote_state.infra_jenkins.infra_jenkins_role_arn}"
        ],
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "core_jenkins_build_policy" {
  name        = "${var.core_vpc_abbrev}_jenkins_build"
  path        = "/"
  description = "allows jenkins to manage ec2/s3 components in ${var.core_vpc_abbrev} vpc"

  policy = <<EOF
{

   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "NonResourceBasedReadOnlyPermissions",
         "Action": [
            "ec2:Describe*",
            "ec2:ImportKeyPair",
            "ec2:DeleteKeyPair",
            "ec2:CreateSecurityGroup",
            "elasticloadbalancing:Describe*",
            "iam:GetInstanceProfiles",
            "iam:ListInstanceProfiles",
            "iam:UploadServerCertificate",
            "iam:ListServerCertificates",
            "acm:ListCertificates",
            "acm:DescribeCertificate",
            "acm:RequestCertificate"
         ],
         "Effect": "Allow",
         "Resource": "*"
      },
      {
         "Sid": "NonResourceBasedBrCustomPermissions",
         "Action": [
            "ec2:AllocateAddress",
            "ec2:ReleaseAddress",
            "ec2:AttachInternetGateway",
            "ec2:AttachNetworkInterface",
            "ec2:DetachNetworkInterface",
            "ec2:DeleteNetworkInterface",
            "ec2:AttachVpnGateway",
            "ec2:MonitorInstances",
            "ec2:UnmonitorInstances",
            "ec2:Associate*",
            "ec2:Create*",
            "ec2:AcceptVpcPeeringConnection",
            "ec2:Disassociate*",
            "ec2:Modify*",
            "ec2:Replace*",
            "ec2:DeleteTags",
            "ec2:AssignPrivateIpAddresses",
            "ec2:UnassignPrivateIpAddresses"
         ],
         "Effect": "Allow",
         "Resource": "*"
      },
      {
         "Sid": "EnvironmentTagBasedPermissions",
         "Action": [
            "ec2:DeleteDhcpOptions"
         ],
         "Effect": "Allow",
         "Resource": "*",
         "Condition": {
            "StringEquals": {
               "ec2:ResourceTag/environment": "${var.core_vpc_abbrev}"
            }
         }
      },
      {
         "Sid": "ELBPermissions",
         "Action": [
            "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
            "elasticloadbalancing:AttachLoadBalancerToSubnets",
            "elasticloadbalancing:ConfigureHealthCheck",
            "elasticloadbalancing:Create*",
            "elasticloadbalancing:Delete*",
            "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
            "elasticloadbalancing:DetachLoadBalancerFromSubnets",
            "elasticloadbalancing:DisableAvailabilityZonesForLoadBalancer",
            "elasticloadbalancing:EnableAvailabilityZonesForLoadBalancer",
            "elasticloadbalancing:ModifyLoadBalancerAttributes",
            "elasticloadbalancing:ModifyTargetGroup",
            "elasticloadbalancing:ModifyTargetGroupAttributes",
            "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
            "elasticloadbalancing:Set*",
            "elasticloadbalancing:AddTags",
            "elasticloadbalancing:CreateTargetGroup",
            "elasticloadbalancing:CreateLoadBalancer",
            "elasticloadbalancing:RemoveTags",
            "elasticloadbalancing:AddListenerCertificates"
         ],
         "Effect": "Allow",
         "Resource": "*"
      },
      {
         "Sid": "AutoScalingPermissions",
         "Effect": "Allow",
         "Action": "autoscaling:*",
         "Resource": "*"
      },
      {
         "Sid": "ElasticachePermissions",
         "Effect": "Allow",
         "Action": "elasticache:*",
         "Resource": "*"
      },
      {
         "Sid": "IAMPassRoleToInstance",
         "Action": [
            "iam:PassRole"

         ],
         "Effect": "Allow",
         "Resource": "arn:aws:iam::${var.br_aws_account_number}:role/${var.core_vpc_abbrev}*"
      },
      {
         "Sid": "AllowInstanceActions",
         "Effect": "Allow",
         "Action": [
            "ec2:RebootInstances",
            "ec2:StopInstances",
            "ec2:TerminateInstances",
            "ec2:RunInstances",
            "ec2:StartInstances",
            "ec2:AttachVolume",
            "ec2:DetachVolume"
         ],
         "Resource": "arn:aws:ec2:${var.core_vpc_region}:${var.br_aws_account_number}:instance/*",
         "Condition": {
            "StringLike": {
               "ec2:InstanceProfile": "arn:aws:iam::${var.br_aws_account_number}:instance-profile/${var.core_vpc_abbrev}*"
            }
         }
      },
      {
         "Sid": "EC2RunInstancesSubnet",
         "Effect": "Allow",
         "Action": "ec2:RunInstances",
         "Resource": "arn:aws:ec2:${var.core_vpc_region}:${var.br_aws_account_number}:subnet/*",
         "Condition": {
            "StringEquals": {
               "ec2:vpc": "arn:aws:ec2:${var.core_vpc_region}:${var.br_aws_account_number}:vpc/${var.core_vpc_id}"
            }
         }
      },
      {
         "Sid": "RemainingRunInstancePermissions",
         "Effect": "Allow",
         "Action": "ec2:RunInstances",
         "Resource": [
            "arn:aws:ec2:${var.core_vpc_region}:${var.br_aws_account_number}:volume/*",
            "arn:aws:ec2:${var.core_vpc_region}::image/*",
            "arn:aws:ec2:${var.core_vpc_region}::snapshot/*",
            "arn:aws:ec2:${var.core_vpc_region}:${var.br_aws_account_number}:network-interface/*",
            "arn:aws:ec2:${var.core_vpc_region}:${var.br_aws_account_number}:key-pair/*",
            "arn:aws:ec2:${var.core_vpc_region}:${var.br_aws_account_number}:security-group/*"
         ]
      },
      {
         "Sid": "EC2VpcNonresourceSpecificActions",
         "Effect": "Allow",
         "Action": [
            "ec2:DeleteNetworkAcl",
            "ec2:DeleteNetworkAclEntry",
            "ec2:DeleteRoute",
            "ec2:DeleteRouteTable",
            "ec2:AuthorizeSecurityGroupEgress",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:RevokeSecurityGroupEgress",
            "ec2:RevokeSecurityGroupIngress",
            "ec2:DeleteSecurityGroup"
         ],
         "Resource": "*",
         "Condition": {
            "StringEquals": {
               "ec2:vpc": [
                   "arn:aws:ec2:${var.core_vpc_region}:${var.br_aws_account_number}:vpc/${var.core_vpc_id}",
                   "arn:aws:ec2:${var.core_vpc_region}:${var.br_aws_account_number}:vpc/${var.cluster_vpc_id}"
                ]
            }
         }
      },
      {
         "Sid": "S3FullAccessToSpecificCoreBuckets",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::${var.core_vpc_abbrev}-*",
                "arn:aws:s3:::${var.core_vpc_abbrev}-*/*",
                "arn:aws:s3:::${var.core_vpc_abbrev}.*",
                "arn:aws:s3:::${var.core_vpc_abbrev}.*/*"
            ]

      },
      {
         "Sid": "S3LsAccessToSpecificCoreBuckets",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": "${aws_s3_bucket.core_terraform_bucket.arn}"
      },
      {
         "Sid": "IamManageExistingServerCertificates",
            "Effect": "Allow",
            "Action": [
                "iam:GetServerCertificate",
                "iam:DeleteServerCertificate",
                "iam:UpdateServerCertificate"
            ],
            "Resource": "arn:aws:iam::${var.br_aws_account_number}:server-certificate/${var.core_vpc_abbrev}*"
      },
      {
         "Sid": "IamManageExistingRoles",
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "iam:PutRolePolicy",
                "iam:GetRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:DeleteRole",
                "iam:CreateRole",
                "iam:ListInstanceProfilesForRole"
            ],
            "Resource": "arn:aws:iam::${var.br_aws_account_number}:role/brcore01*"
      },
      {
         "Sid": "IamManageExistingInstanceProfiles",
            "Effect": "Allow",
            "Action": [
                "iam:GetInstanceProfile",
                "iam:CreateInstanceProfile",
                "iam:AddRoleToInstanceProfile",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:DeleteInstanceProfile"
            ],
            "Resource": "arn:aws:iam::${var.br_aws_account_number}:instance-profile/brcore01*"
      },
      {
         "Sid": "ElasticFileSystemPolicies",
            "Effect": "Allow",
            "Action": [
                "elasticfilesystem:*"
            ],
            "Resource": "arn:aws:elasticfilesystem:${var.core_vpc_region}:${var.br_aws_account_number}:file-system/*"
      },
      {
         "Sid": "ElasticFileSystemPoliciesGlobal",
            "Effect": "Allow",
            "Action": [
                "elasticfilesystem:DescribeTags",
                "elasticfilesystem:DescribeFileSystems"
            ],
            "Resource": "*"
      }
   ]
}
EOF
}

data "aws_iam_policy_document" "core_jenkins_build_policy2" {
  statement = [
    {
      sid     = "S3FullAccessToSpecificCoreBuckets"
      actions = ["s3:*"]

      resources = [
        "arn:aws:s3:::br-elasticsearch",
        "arn:aws:s3:::br-elasticsearch/*",
      ]
    },
    {
      sid = "infraDestroyNonResourceOrConditionActions"

      actions = [
        "ec2:DeleteSubnet",
        "ec2:DeleteNatGateway",
        "ec2:DeleteVpc",
        "ec2:EnableVgwRoutePropagation",
      ]

      resources = [
        "*",
      ]
    },
  ]
}

resource "aws_iam_policy" "core_jenkins_build_policy2" {
  name   = "${var.core_vpc_abbrev}_jenkins_build2"
  path   = "/"
  policy = "${data.aws_iam_policy_document.core_jenkins_build_policy2.json}"
}

resource "aws_iam_policy" "core_jenkins_route53_policy" {
  name        = "${var.core_vpc_abbrev}_jenkins_route53"
  path        = "/"
  description = "allows jenkins to manage route53 components in ${var.core_vpc_abbrev} vpc"

  policy = <<EOF
{

   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "Route53GlobalPermissions",
         "Effect": "Allow",
         "Action": [
            "route53:CreateHostedZone",
            "route53:GetHostedZone",
            "route53:ListHostedZones",
            "route53:GetChange"
          ],
         "Resource": "*"
      },
      {
         "Sid": "Route53SpecificHostedZonePermissions",
         "Effect": "Allow",
         "Action": [
            "route53:DeleteHostedZone",
            "route53:AssociateHostedZoneWithVPC",
            "route53:AssociateVPCWithHostedZone",
            "route53:DisassociateVPCFromHostedZone",
            "route53:GetHostedZoneCount",
            "route53:ListHostedZones",
            "route53:ListHostedZonesByName",
            "route53:UpdateHostedZoneComment",
            "route53:ListResourceRecordSets",
            "route53:ChangeResourceRecordSets",
            "route53:ListTagsForResource",
            "route53:ChangeTagsForResource"
          ],
         "Resource": [
            "arn:aws:route53:::hostedzone/*",
            "arn:aws:route53:::tags/hostedzone/*"
         ]
      }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "core_jenkins_build_attach" {
  role       = "${aws_iam_role.core_jenkins_build_role.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_build_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "core_jenkins_route53_attach" {
  role       = "${aws_iam_role.core_jenkins_build_role.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_route53_policy.arn}"
}

resource "aws_iam_policy" "core_jenkins_rds_policy" {
  name        = "${var.core_vpc_abbrev}_jenkins_rds"
  path        = "/"
  description = "allows jenkins to manage rds components in ${var.core_vpc_abbrev} vpc"

  policy = <<EOF
{

   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "RDSCreatePermissionsRestricted",
         "Effect": "Allow",
         "Action": [
            "rds:CreateDBSubnetGroup",
            "rds:DescribeDBSubnetGroups",
            "rds:DescribeDBInstances",
            "rds:ModifyDBInstance",
            "rds:ListTagsForResource",
            "rds:AddTagsToResource",
            "rds:CreateDBInstance",
            "rds:DeleteDBInstance",
            "rds:ModifyDBSubnetGroup",
            "rds:DeleteDBSubnetGroup",
            "rds:DescribeDBParameterGroups",
            "rds:DescribeDBParameters",
            "rds:CreateDBParameterGroup",
            "rds:ModifyDBParameterGroup",
            "rds:DeleteDBParameterGroup"
          ],
         "Resource": [
            "arn:aws:rds:us-east-1:${var.br_aws_account_number}:db:${var.core_vpc_abbrev}*",
            "arn:aws:rds:us-east-1:${var.br_aws_account_number}:og:default:mysql-5-6",
            "arn:aws:rds:us-east-1:${var.br_aws_account_number}:pg:default.mysql5.6",
            "arn:aws:rds:us-east-1:${var.br_aws_account_number}:pg:default.postgres9.4",
            "arn:aws:rds:us-east-1:${var.br_aws_account_number}:db:${var.core_vpc_abbrev}*",
            "arn:aws:rds:us-east-1:${var.br_aws_account_number}:subgrp:${var.core_vpc_abbrev}*",
            "arn:aws:rds:us-east-1:${var.br_aws_account_number}:pg:${var.core_vpc_abbrev}*"
         ]
      }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "core_jenkins_rds_attach" {
  role       = "${aws_iam_role.core_jenkins_build_role.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_rds_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "core_jenkins_iam_attach" {
  role       = "${aws_iam_role.core_jenkins_build_role.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_iam_policy.arn}"
}

resource "aws_iam_policy" "core_jenkins_iam_policy" {
  name        = "${var.core_vpc_abbrev}_jenkins_iam"
  path        = "/"
  description = "allows jenkins to manage iam components in ${var.core_vpc_abbrev} vpc"

  policy = <<EOF
{

   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "IAMPermissionsRestricted",
         "Effect": "Allow",
         "Action": [
            "iam:*"
          ],
         "Resource": [
            "arn:aws:iam::${var.br_aws_account_number}:policy/${var.core_vpc_abbrev}*",
            "arn:aws:iam::${var.br_aws_account_number}:role/${var.core_vpc_abbrev}*",
            "arn:aws:iam::${var.br_aws_account_number}:server-certificate/${var.core_vpc_abbrev}*",
            "arn:aws:iam::${var.br_aws_account_number}:instance-profile/${var.core_vpc_abbrev}*"
         ]
      },
      {
         "Sid": "S3FullAccessToSpecificBrnpBuckets",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::platform-terraform-assets",
                "arn:aws:s3:::platform-terraform-assets/*"
            ]

      }
    ]
}
EOF
}

resource "aws_iam_policy" "core_jenkins_lambda_policy" {
  name        = "${var.core_vpc_abbrev}_jenkins_lambda"
  path        = "/"
  description = "allows jenkins to manage lambda components in ${var.core_vpc_abbrev} vpc"

  policy = <<EOF
{

   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "LambdaPermissionsRestricted",
         "Effect": "Allow",
         "Action": [
            "lambda:CreateFunction",
            "lambda:DeleteFunction",
            "lambda:GetFunction",
            "lambda:ListVersionsByFunction",
            "lambda:AddPermission",
            "lambda:RemovePermission",
            "lambda:GetPolicy",
            "lambda:UpdateFunctionCode",
            "lambda:UpdateFunctionConfiguration"
          ],
         "Resource": [
            "arn:aws:lambda:us-east-1:${var.br_aws_account_number}:function:*"
         ]
      }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "core_jenkins_lambda_attach" {
  role       = "${aws_iam_role.core_jenkins_build_role.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_lambda_policy.arn}"
}

resource "aws_iam_policy" "core_jenkins_event_policy" {
  name        = "${var.core_vpc_abbrev}_jenkins_event"
  path        = "/"
  description = "allows jenkins to manage event components in ${var.core_vpc_abbrev} vpc"

  policy = <<EOF
{

   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "EventPermissionsRestricted",
         "Effect": "Allow",
         "Action": [
            "events:PutRule",
            "events:EnableRule",
            "events:DescribeRule",
            "events:PutTargets",
            "events:ListTargetsByRule",
            "events:DeleteRule",
            "events:RemoveTargets"
          ],
         "Resource": [
            "arn:aws:events:us-east-1:${var.br_aws_account_number}:rule/snapshot_cleanup_lambda_daily",
            "arn:aws:events:us-east-1:${var.br_aws_account_number}:rule/${var.core_vpc_abbrev}*"
         ]
      }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "core_jenkins_event_attach" {
  role       = "${aws_iam_role.core_jenkins_build_role.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_event_policy.arn}"
}

resource "aws_iam_policy" "core_jenkins_sqs_policy" {
  name        = "${var.core_vpc_abbrev}_jenkins_sqs"
  description = "Allow jenkins to manage SQS queues in ${var.core_vpc_abbrev}"
  policy      = "${data.aws_iam_policy_document.core_jenkins_sqs_policy.json}"
}

resource "aws_iam_role_policy_attachment" "core_jenkins_sqs_attach" {
  role       = "${aws_iam_role.core_jenkins_build_role.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_sqs_policy.arn}"
}

resource "aws_iam_policy" "core_jenkins_kms_policy" {
  name        = "${var.core_vpc_abbrev}_jenkins_kms"
  description = "Allow jenkins to manage KMS resources in ${var.core_vpc_abbrev}"
  policy      = "${data.aws_iam_policy_document.core_jenkins_kms_policy.json}"
}

resource "aws_iam_role_policy_attachment" "core_jenkins_kms_attach" {
  role       = "${aws_iam_role.core_jenkins_build_role.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_kms_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "core_jenkins_build_policy2" {
  role       = "${aws_iam_role.core_jenkins_build_role.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_build_policy2.arn}"
}

resource "aws_iam_role" "kms-admin" {
  name = "${var.core_vpc_abbrev}-kms-admin"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${var.br_aws_account_number}:root"
        ],
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "core_jenkins_sqs_policy" {
  statement {
    sid = "SQSAccessRestricted"

    actions = [
      "sqs:AddPermission",
      "sqs:ChangeMessageVisibility",
      "sqs:ChangeMessageVisibilityBatch",
      "sqs:CreateQueue",
      "sqs:DeleteMessage",
      "sqs:DeleteMessageBatch",
      "sqs:DeleteQueue",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ListDeadLetterSourceQueues",
      "sqs:ListQueues",
      "sqs:ListQueueTags",
      "sqs:PurgeQueue",
      "sqs:ReceiveMessage",
      "sqs:RemovePermission",
      "sqs:SendMessage",
      "sqs:SendMessageBatch",
      "sqs:SetQueueAttributes",
      "sqs:TagQueue",
      "sqs:UntagQueue",
    ]

    resources = [
      "arn:aws:sqs:us-east-1:${var.br_aws_account_number}:io-hmheng-infra-${var.core_vpc_abbrev}*",
    ]
  }
}

data "aws_iam_policy_document" "core_jenkins_kms_policy" {
  statement {
    sid = "kmsCreateFull"

    actions = [
      "kms:CreateKey",
      "kms:ScheduleKeyDeletion",
      "kms:UpdateKeyDescription",
      "kms:DescribeKey",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:CreateAlias",
      "kms:CreateAlias",
      "kms:DeleteAlias",
      "kms:UpdateAlias",
      "kms:ListAliases",
      "kms:ListResourceTags",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:Get*",
      "kms:List*",
      "kms:Put*",
      "kms:ScheduleKeyDeletion",
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "artifactory" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.artifactory_bucket.arn}",
      "${aws_s3_bucket.artifactory_bucket.arn}/*",
    ]
  }
}

data "terraform_remote_state" "infra_jenkins" {
  backend = "local"

  config {
    path = "${path.module}/../infra-jenkins/terraform.tfstate"
  }
}

resource "aws_iam_user" "tf" {
  name = "terraform-${var.core_vpc_abbrev}"
}

resource "aws_iam_user_policy_attachment" "user-core_jenkins_build_attach" {
  user       = "${aws_iam_user.tf.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_build_policy.arn}"
}

resource "aws_iam_user_policy_attachment" "user-core_jenkins_route53_attach" {
  user       = "${aws_iam_user.tf.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_route53_policy.arn}"
}

resource "aws_iam_user_policy_attachment" "user-core_jenkins_rds_attach" {
  user       = "${aws_iam_user.tf.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_rds_policy.arn}"
}

resource "aws_iam_user_policy_attachment" "user-core_jenkins_iam_attach" {
  user       = "${aws_iam_user.tf.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_iam_policy.arn}"
}

resource "aws_iam_user_policy_attachment" "user-core_jenkins_lambda_attach" {
  user       = "${aws_iam_user.tf.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_lambda_policy.arn}"
}

resource "aws_iam_user_policy_attachment" "user-core_jenkins_event_attach" {
  user       = "${aws_iam_user.tf.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_event_policy.arn}"
}

resource "aws_iam_user_policy_attachment" "user-core_jenkins_sqs_attach" {
  user       = "${aws_iam_user.tf.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_sqs_policy.arn}"
}

resource "aws_iam_user_policy_attachment" "user-core_jenkins_kms_attach" {
  user       = "${aws_iam_user.tf.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_kms_policy.arn}"
}

resource "aws_iam_user_policy_attachment" "user-core_jenkins_build_policy2" {
  user       = "${aws_iam_user.tf.name}"
  policy_arn = "${aws_iam_policy.core_jenkins_build_policy2.arn}"
}

resource "aws_iam_user" "artifactory" {
  name = "${var.artifactory_bucket_name}"
}

resource "aws_iam_policy" "artifactory_s3" {
  name        = "${var.core_vpc_abbrev}.artifactory.s3"
  description = "Grant Artifactory full access to Artifactory S3 bucket in ${var.core_vpc_abbrev}"
  policy      = "${data.aws_iam_policy_document.artifactory.json}"
}

resource "aws_iam_user_policy_attachment" "artifactory_s3" {
  user       = "${aws_iam_user.artifactory.name}"
  policy_arn = "${aws_iam_policy.artifactory_s3.arn}"
}
