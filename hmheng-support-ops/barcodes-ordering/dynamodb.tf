/* DynamoDb Tables */
resource "aws_dynamodb_table" "obo-users-table" {
  name           = "${var.stage}-users"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "userName"

  attribute {
    name = "userName"
    type = "S"
  }

  tags {
    Name              = "${var.aurora_role}-${var.service_name}-users-DDB-table"
    cost              = "${var.cost}"
    responsible-party = "${var.contact}"
  }
}

resource "aws_dynamodb_table" "obo-users-data-table" {
  name           = "${var.stage}-usersData"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "userID"

  attribute {
    name = "userID"
    type = "S"
  }

  tags {
    Name              = "${var.aurora_role}-${var.service_name}-usersData-DDB-table"
    cost              = "${var.cost}"
    responsible-party = "${var.contact}"
  }
}

data "aws_iam_policy_document" "dynamodb-iam-role-policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.br_aws_account_number}:root"]
    }
  }
}

resource "aws_iam_role" "dynamodb-iam-role" {
  name               = "${var.service_name}-iam-ddb-role-${var.stage}"
  path               = "/${var.service_name}/"
  assume_role_policy = "${data.aws_iam_policy_document.dynamodb-iam-role-policy.json}"
}

data "aws_iam_policy_document" "dynamodb-rw-role" {
  statement {
    effect = "Allow"

    actions = ["dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
      "dynamodb:DescribeTable",
      "dynamodb:ListTables",
    ]

    resources = ["${aws_dynamodb_table.obo-users-table.arn}",
      "${aws_dynamodb_table.obo-users-data-table.arn}",
    ]
  }
}

resource "aws_iam_role_policy" "dynamodb-iam-policy" {
  name   = "DynamoDB-access"
  role   = "${aws_iam_role.dynamodb-iam-role.id}"
  policy = "${data.aws_iam_policy_document.dynamodb-rw-role.json}"
}
