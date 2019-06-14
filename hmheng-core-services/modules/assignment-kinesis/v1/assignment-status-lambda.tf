resource "aws_lambda_function" "assignment-status-lambda" {
  s3_bucket = "${aws_s3_bucket.hmheng-core-services-s3-bucket.id}"
  s3_key = "${var.app_name}/lambda/assignment-lambda-0.0.9-SNAPSHOT.jar"
  source_code_hash = "${base64sha256(file("resources/assignment-lambda-0.0.9-SNAPSHOT.jar"))}"
  handler = "com.hmhco.lambda.assignment.aws.lambda.AssignmentStatusHandler"
  function_name = "${var.aurora_role}-${var.tag_stage}-assignment-status"
  runtime = "java8"
  timeout = "120"
  description = "Lambda which sets the status of an assignment from Learnosity/Grading"
  role = "${aws_iam_role.iam_role_for_assignment_status_lambda.arn}"
}

resource "aws_iam_role" "iam_role_for_assignment_status_lambda" {
  name               = "io.hmheng.core-services.${var.tag_stage}_assignment_status_lambda"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_execution_role.json}"
}

data "aws_iam_policy_document" "lambda_execution_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_iam_policy_basic_execution" {
  role = "${aws_iam_role.iam_role_for_assignment_status_lambda.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_iam_policy_kinesis_execution" {
  role = "${aws_iam_role.iam_role_for_assignment_status_lambda.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole"
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_iam_policy_vpc_access_execution" {
  role = "${aws_iam_role.iam_role_for_assignment_status_lambda.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_event_source_mapping" "kinesis_lambda_event_mapping" {
  batch_size = 100
  event_source_arn = "${aws_kinesis_stream.hmheng-core-services-hmhone-assessment-status.arn}"
  enabled = true
  function_name = "${aws_lambda_function.assignment-status-lambda.arn}"
  starting_position = "TRIM_HORIZON"
}
