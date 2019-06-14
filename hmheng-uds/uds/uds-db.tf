/* DynamoDb Tables */
resource "aws_dynamodb_table" "uds-calculated-behavior-table" {
  name           = "${var.service_name}-${var.stage}-calculated-behavior"
  read_capacity  = "${lookup(var.calculated_behavior_read_capacity_by_stage, var.stage)}"
  write_capacity = "${lookup(var.calculated_behavior_write_capacity_by_stage, var.stage)}"
  hash_key       = "user"
  range_key      = "key"

  attribute {
    name = "user"
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

resource "aws_dynamodb_table" "uds-apps-table" {
  name           = "${var.service_name}-${var.stage}-apps"
  read_capacity  = "${lookup(var.apps_read_capacity_by_stage, var.stage)}"
  write_capacity = "${lookup(var.apps_write_capacity_by_stage, var.stage)}"
  hash_key       = "name"

  attribute {
    name = "name"
    type = "S"
  }

  tags {
    Name              = "${var.aurora_role}-${var.service_name}-apps-DDB-table"
    cost              = "${var.cost}"
    responsible-party = "${var.contact}"
  }
}

resource "aws_dynamodb_table" "uds-app-data-json-table" {
  name           = "${var.service_name}-${var.stage}-app-data-json"
  read_capacity  = "${lookup(var.app_data_json_read_capacity_by_stage, var.stage)}"
  write_capacity = "${lookup(var.app_data_json_write_capacity_by_stage, var.stage)}"
  hash_key       = "appUser"
  range_key      = "key"

  attribute {
    name = "appUser"
    type = "S"
  }

  attribute {
    name = "key"
    type = "S"
  }

  attribute {
    name = "user"
    type = "S"
  }

  attribute {
    name = "appKey"
    type = "S"
  }

  global_secondary_index {
    name               = "uds-app-data-json-gsi"
    hash_key           = "user"
    range_key          = "appKey"
    write_capacity     = "${lookup(var.app_data_json_gsi_write_capacity_by_stage, var.stage)}"
    read_capacity      = "${lookup(var.app_data_json_gsi_read_capacity_by_stage, var.stage)}"
    projection_type    = "ALL"
  }

  tags {
    Name              = "${var.aurora_role}-${var.service_name}-app-data-json-DDB-table"
    cost              = "${var.cost}"
    responsible-party = "${var.contact}"
  }
}

resource "aws_dynamodb_table" "uds-authz-table" {
  name           = "${var.service_name}-${var.stage}-authz"
  read_capacity  = "${lookup(var.authz_read_capacity_by_stage, var.stage)}"
  write_capacity = "${lookup(var.authz_write_capacity_by_stage, var.stage)}"
  hash_key       = "name"

  attribute {
    name = "name"
    type = "S"
  }

  tags {
    Name              = "${var.aurora_role}-${var.service_name}-authz-DDB-table"
    cost              = "${var.cost}"
    responsible-party = "${var.contact}"
  }
}

resource "aws_dynamodb_table" "uds-share-table" {
  name           = "${var.service_name}-${var.stage}-share"
  read_capacity  = "${lookup(var.share_read_capacity_by_stage, var.stage)}"
  write_capacity = "${lookup(var.share_write_capacity_by_stage, var.stage)}"
  hash_key       = "key"

  attribute {
    name = "key"
    type = "S"
  }

  attribute {
    name = "user"
    type = "S"
  }

  global_secondary_index {
    name               = "uds-share-by-user-gsi"
    hash_key           = "user"
    range_key          = "key"
    write_capacity     = "${lookup(var.share_by_user_gsi_write_capacity_by_stage, var.stage)}"
    read_capacity      = "${lookup(var.share_by_user_gsi_read_capacity_by_stage, var.stage)}"
    projection_type    = "KEYS_ONLY"
  }

  tags {
    Name              = "${var.aurora_role}-${var.service_name}-share-DDB-table"
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

    resources = [
      "${aws_dynamodb_table.uds-calculated-behavior-table.arn}",
      "${aws_dynamodb_table.uds-apps-table.arn}",
      "${aws_dynamodb_table.uds-app-data-json-table.arn}",
      "${aws_dynamodb_table.uds-app-data-json-table.arn}/index/*",
      "${aws_dynamodb_table.uds-authz-table.arn}",
      "${aws_dynamodb_table.uds-share-table.arn}",
      "${aws_dynamodb_table.uds-share-table.arn}/index/*",
    ]
  }
}

resource "aws_iam_role_policy" "dynamodb-iam-policy" {
  name   = "DynamoDB-access"
  role   = "${aws_iam_role.dynamodb-iam-role.id}"
  policy = "${data.aws_iam_policy_document.dynamodb-rw-role.json}"
}

# Autoscaling configuration
# Tables: uds-share-table uds-calculated-behavior-table uds-apps-table uds-app-data-json-table uds-authz-table
# Indexes: uds-app-data-json-gsi uds-share-by-user-gsi

module "cb_autoscaling" {
  source = "./modules/autoscaling"

  resource_id = "table/${aws_dynamodb_table.uds-calculated-behavior-table.name}"
  min_write_capacity = "${lookup(var.calculated_behavior_write_capacity_by_stage, var.stage)}"
  min_read_capacity = "${lookup(var.calculated_behavior_read_capacity_by_stage, var.stage)}"
  max_write_capacity = "${lookup(var.calculated_behavior_write_capacity_by_stage, var.stage)}00"
  max_read_capacity = "${lookup(var.calculated_behavior_read_capacity_by_stage, var.stage)}00"
  scalable_dimension_type = "table"
}

module "apps_autoscaling" {
  source = "./modules/autoscaling"

  resource_id = "table/${aws_dynamodb_table.uds-apps-table.name}"
  min_write_capacity = "${lookup(var.apps_write_capacity_by_stage, var.stage)}"
  min_read_capacity = "${lookup(var.apps_read_capacity_by_stage, var.stage)}"
  max_write_capacity = "${lookup(var.apps_write_capacity_by_stage, var.stage)}00"
  max_read_capacity = "${lookup(var.apps_read_capacity_by_stage, var.stage)}00"
  scalable_dimension_type = "table"
}

module "app_data_autoscaling" {
  source = "./modules/autoscaling"

  resource_id = "table/${aws_dynamodb_table.uds-app-data-json-table.name}"
  min_write_capacity = "${lookup(var.app_data_json_write_capacity_by_stage, var.stage)}"
  min_read_capacity = "${lookup(var.app_data_json_read_capacity_by_stage, var.stage)}"
  max_write_capacity = "${lookup(var.app_data_json_write_capacity_by_stage, var.stage)}00"
  max_read_capacity = "${lookup(var.app_data_json_read_capacity_by_stage, var.stage)}00"
  scalable_dimension_type = "table"
}

# "${aws_dynamodb_table.uds-authz-table.arn}"
module "authz_autoscaling" {
  source = "./modules/autoscaling"

  resource_id = "table/${aws_dynamodb_table.uds-authz-table.name}"
  min_write_capacity = "${lookup(var.authz_write_capacity_by_stage, var.stage)}"
  min_read_capacity = "${lookup(var.authz_read_capacity_by_stage, var.stage)}"
  max_write_capacity = "${lookup(var.authz_write_capacity_by_stage, var.stage)}00"
  max_read_capacity = "${lookup(var.authz_read_capacity_by_stage, var.stage)}00"
  scalable_dimension_type = "table"
}

# "${aws_dynamodb_table.uds-share-table.arn}"
module "share_autoscaling" {
  source = "./modules/autoscaling"

  resource_id = "table/${aws_dynamodb_table.uds-share-table.name}"
  min_write_capacity = "${lookup(var.share_write_capacity_by_stage, var.stage)}"
  min_read_capacity = "${lookup(var.share_read_capacity_by_stage, var.stage)}"
  max_write_capacity = "${lookup(var.share_write_capacity_by_stage, var.stage)}00"
  max_read_capacity = "${lookup(var.share_read_capacity_by_stage, var.stage)}00"
  scalable_dimension_type = "table"
}

# Indexes
# uds-app-data-json-gsi
module "app_data_gsi_autoscaling" {
  source = "./modules/autoscaling"

  resource_id = "table/${aws_dynamodb_table.uds-app-data-json-table.name}/index/uds-app-data-json-gsi"
  min_write_capacity = "${lookup(var.app_data_json_gsi_write_capacity_by_stage, var.stage)}"
  min_read_capacity = "${lookup(var.app_data_json_gsi_read_capacity_by_stage, var.stage)}"
  max_write_capacity = "${lookup(var.app_data_json_gsi_write_capacity_by_stage, var.stage)}00"
  max_read_capacity = "${lookup(var.app_data_json_gsi_read_capacity_by_stage, var.stage)}00"
  scalable_dimension_type = "index"
}

# uds-share-by-user-gsi
module "share_by_user_gsi_autoscaling" {
  source = "./modules/autoscaling"

  resource_id = "table/${aws_dynamodb_table.uds-share-table.name}/index/uds-share-by-user-gsi"
  min_write_capacity = "${lookup(var.share_by_user_gsi_write_capacity_by_stage, var.stage)}"
  min_read_capacity = "${lookup(var.share_by_user_gsi_read_capacity_by_stage, var.stage)}"
  max_write_capacity = "${lookup(var.share_by_user_gsi_write_capacity_by_stage, var.stage)}00"
  max_read_capacity = "${lookup(var.share_by_user_gsi_read_capacity_by_stage, var.stage)}00"
  scalable_dimension_type = "index"
}
