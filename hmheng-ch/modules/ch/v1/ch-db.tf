resource "aws_dynamodb_table" "ch-calculated-behavior-table" {
  name           = "${var.service_name}-${var.stage}-calculated-behavior"
  read_capacity  = "${var.calculated_behavior_read_capacity}"
  write_capacity = "${var.calculated_behavior_write_capacity}"
  hash_key       = "classId"
  range_key      = "key"

  attribute {
    name = "classId"
    type = "S"
  }

  attribute {
    name = "key"
    type = "S"
  }

  tags {
    Name              = "${var.aurora_role}-${var.service_name}-calculated-behavior-DDB-table"
    cost              = "${var.cost}"
    responsible-party = "${var.contact}"
  }
}

resource "aws_dynamodb_table" "ch-class-content-table" {
  name           = "${var.service_name}-${var.stage}-class-content"
  read_capacity  = "${var.class_content_read_capacity}"
  write_capacity = "${var.class_content_write_capacity}"
  hash_key       = "classId"
  range_key      = "key"

  attribute {
    name = "classId"
    type = "S"
  }

  attribute {
    name = "key"
    type = "S"
  }

  tags {
    Name              = "${var.aurora_role}-${var.service_name}-class-content-DDB-table"
    cost              = "${var.cost}"
    responsible-party = "${var.contact}"
  }
}

resource "aws_dynamodb_table" "ch-class-object-table" {
  name           = "${var.service_name}-${var.stage}-class-object"
  read_capacity  = "${var.class_object_read_capacity}"
  write_capacity = "${var.class_object_write_capacity}"
  hash_key       = "classId"

  attribute {
    name = "classId"
    type = "S"
  }

  tags {
    Name              = "${var.aurora_role}-${var.service_name}-class-object-DDB-table"
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

    actions = [
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

    resources = [
      "${aws_dynamodb_table.ch-calculated-behavior-table.arn}",
      "${aws_dynamodb_table.ch-class-content-table.arn}",
      "${aws_dynamodb_table.ch-class-object-table.arn}",
    ]
  }
}

resource "aws_iam_role_policy" "dynamodb-iam-policy" {
  name   = "${var.service_name}-${var.stage}"
  role   = "${aws_iam_role.dynamodb-iam-role.id}"
  policy = "${data.aws_iam_policy_document.dynamodb-rw-role.json}"
}

module "calculated_behavior_autoscaling" {
  source = "../autoscaling"

  resource_id = "table/${aws_dynamodb_table.ch-calculated-behavior-table.name}"
  min_write_capacity = "${aws_dynamodb_table.ch-calculated-behavior-table.write_capacity}"
  min_read_capacity = "${aws_dynamodb_table.ch-calculated-behavior-table.read_capacity}"
  max_write_capacity = "${aws_dynamodb_table.ch-calculated-behavior-table.write_capacity}00"
  max_read_capacity = "${aws_dynamodb_table.ch-calculated-behavior-table.read_capacity}00"
  scalable_dimension_type = "table"
}

module "class_content_autoscaling" {
  source = "../autoscaling"

  resource_id = "table/${aws_dynamodb_table.ch-class-content-table.name}"
  min_write_capacity = "${aws_dynamodb_table.ch-class-content-table.write_capacity}"
  min_read_capacity = "${aws_dynamodb_table.ch-class-content-table.read_capacity}"
  max_write_capacity = "${aws_dynamodb_table.ch-class-content-table.write_capacity}00"
  max_read_capacity = "${aws_dynamodb_table.ch-class-content-table.read_capacity}00"
  scalable_dimension_type = "table"
}

module "class_object_autoscaling" {
  source = "../autoscaling"

  resource_id = "table/${aws_dynamodb_table.ch-class-object-table.name}"
  min_write_capacity = "${aws_dynamodb_table.ch-class-object-table.write_capacity}"
  min_read_capacity = "${aws_dynamodb_table.ch-class-object-table.read_capacity}"
  max_write_capacity = "${aws_dynamodb_table.ch-class-object-table.write_capacity}00"
  max_read_capacity = "${aws_dynamodb_table.ch-class-object-table.read_capacity}00"
  scalable_dimension_type = "table"
}
