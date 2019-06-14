resource "aws_iam_role" "datadog" {
    name = "datadog_iam_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.datadog_account_id}"
      },
      "Action": "sts:AssumeRole",
      "Condition":{
        "StringEquals": {
          "sts:ExternalId": "${var.datadog_external_id}"
        }
      }
    }
  ]
}
EOF
}


resource "aws_iam_policy" "datadog_policy" {
    name = "datadog_policy"
    path = "/"
    description = "allows datadog to access components in bedrock account"
    policy = <<EOF
{

   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "NonResourceBasedReadOnlyPermissions",
         "Action": [
            "autoscaling:Describe*",
            "budgets:ViewBudget",
            "cloudtrail:DescribeTrails",
            "cloudtrail:GetTrailStatus",
            "cloudwatch:Describe*",
            "cloudwatch:Get*",
            "cloudwatch:List*",
            "codedeploy:List*",
            "codedeploy:BatchGet*",
            "dynamodb:list*",
            "dynamodb:describe*",
            "ec2:Describe*",
            "ec2:Get*",
            "ecs:Describe*",
            "ecs:List*",
            "elasticache:Describe*",
            "elasticache:List*",
            "elasticfilesystem:DescribeFileSystems",
            "elasticfilesystem:DescribeTags",
            "elasticloadbalancing:Describe*",
            "elasticmapreduce:List*",
            "elasticmapreduce:Describe*",
            "es:ListTags",
            "es:ListDomainNames",
            "es:DescribeElasticsearchDomains",
            "kinesis:List*",
            "kinesis:Describe*",
            "lambda:List*",
            "logs:Get*",
            "logs:Describe*",
            "logs:FilterLogEvents",
            "logs:TestMetricFilter",
            "rds:Describe*",
            "rds:List*",
            "route53:List*",
            "s3:GetBucketTagging",
            "s3:ListAllMyBuckets",
            "ses:Get*",
            "sns:List*",
            "sns:Publish",
            "sqs:ListQueues",
            "support:*",
            "tag:getResources",
            "tag:getTagKeys",
            "tag:getTagValues"
         ],
         "Effect": "Allow",
         "Resource": "*"
      }
   ]
}
EOF
}


resource "aws_iam_policy_attachment" "datadog_attach" {
    name = "datadog"
    roles = ["${aws_iam_role.datadog.name}"]
    policy_arn = "${aws_iam_policy.datadog_policy.arn}"
}
