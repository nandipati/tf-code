data "aws_iam_policy_document" "data-services-access-policy-doc" {
  statement {
    actions = [
      "logs:Describe*",
      "logs:Get*",
      "logs:TestMetricFilter",
      "logs:FilterLogEvents",
    ]

    resources = [
      "arn:aws:logs:us-east-1:711638685743:log-group:/aws/lambda/s3_put_object_${var.tag_stage}:*:*"
    ]
  }

  statement {
    actions = [
      "athena:GetExecutionEngine",
      "athena:GetExecutionEngines",
      "athena:GetNamespace",
      "athena:GetNamespaces",
      "athena:GetQueryExecution",
      "athena:GetQueryExecutions",
      "athena:GetQueryResults",
      "athena:GetTable",
      "athena:GetTables",
      "athena:StartQueryExecution"
    ]

    resources = [
      "arn:aws:athena:*:*:*",
    ]
  }

  statement {
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }

  # For AWS Console Access
  statement {
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::hmheng-data-services/event-storage/athena-metastore",
      "arn:aws:s3:::hmheng-data-services/event-storage/athena-metastore/*",
      "arn:aws:s3:::hmheng-data-services/event-storage/${var.tag_stage}",
      "arn:aws:s3:::hmheng-data-services/event-storage/${var.tag_stage}/*",
      "arn:aws:s3:::hmheng-data-services/${var.tag_stage}/userevents",
      "arn:aws:s3:::hmheng-data-services/${var.tag_stage}/userevents/*",
      "arn:aws:s3:::hmheng-data-services/pipeline-events/${var.tag_stage}",
      "arn:aws:s3:::hmheng-data-services/pipeline-events/${var.tag_stage}/*",
      "arn:aws:s3:::hmheng-data-services/druid-segments/${var.tag_stage}",
      "arn:aws:s3:::hmheng-data-services/druid-segments/${var.tag_stage}/*",
    ]
  }
}

resource "aws_iam_policy" "data-services-access-policy" {
  name        = "io.hmheng.dataservices.${var.tag_stage}.event-access.crossaccount"
  path        = "/"
  description = "data services ${var.tag_stage} s3, cloudwatch log access policy"
  policy      = "${data.aws_iam_policy_document.data-services-access-policy-doc.json}"
}

resource "aws_iam_policy_attachment" "data-services-access" {
  name = "data_services_${var.tag_stage}_access"

  roles = [
    "${aws_iam_role.dataservices-access-role.name}",
  ]

  policy_arn = "${aws_iam_policy.data-services-access-policy.arn}"
}

resource "aws_iam_role" "dataservices-access-role" {
  name               = "io.hmheng.dataservices.${var.tag_stage}.event-access.crossaccount"
  assume_role_policy = "${data.aws_iam_policy_document.data_services_assumerole.json}"
}

data "aws_iam_policy_document" "data_services_assumerole" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${lookup(var.dub_acct_id, var.tag_stage)}:root",
        "arn:aws:iam::${var.br_aws_account_number}:root"
      ]
    }
  }
}
