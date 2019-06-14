resource "aws_lambda_permission" "main_with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.obo_main_lambda.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.obo-generatePDF-sns.arn}"
}

resource "aws_sns_topic_subscription" "main_lambda" {
  topic_arn = "${aws_sns_topic.obo-generatePDF-sns.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.obo_main_lambda.arn}"
}

resource "aws_lambda_function" "obo_main_lambda" {
  s3_bucket        = "${aws_s3_bucket.support-ops-s3-bucket.id}"
  s3_key           = "${var.app_name}/Lambdas_code/${var.stage}/obo_main_lambda_function.zip"
  function_name    = "${var.stage}-obo_main_lambda_function"
  role             = "${aws_iam_role.iam_role_for_main_lambda.arn}"
  handler          = "bi_lambda.lambda_handler"
  source_code_hash = "${base64sha256("${var.app_name}/lambdas_code/${var.stage}/obo_main_lambda_function.zip")}"
  runtime          = "python2.7"
  timeout          = 90
  description      = "BI Generator: takes a json as input, and generates a PDF Transmittal Form."

  environment {
    variables = {
      BUCKET_NAME        = "${aws_s3_bucket.support-ops-s3-bucket.id}"
      SFTP_SNS_TOPIC_ARN = "${aws_sns_topic.obo-sftpNotification-sns.arn}"
      BLANK_PDF_FORM     = "${var.app_name}/${var.stage}/blank_pdf_forms/Barcode_Order_Form.pdf"
      S3_APP_PATH        = "${var.app_name}/${var.stage}"
      STAGE              = "${var.stage}"
    }
  }
}

resource "aws_iam_role" "iam_role_for_main_lambda" {
  name               = "${var.stage}-iam_role_for_main_lambda"
  path               = "/${var.service_name}/"
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

resource "aws_iam_role_policy_attachment" "main_lambda_aws_execute" {
  role       = "${aws_iam_role.iam_role_for_main_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_iam_role_policy_attachment" "main_lambda_vpc_access_execution" {
  role       = "${aws_iam_role.iam_role_for_main_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "main_lambda_publish_to_sns" {
  role       = "${aws_iam_role.iam_role_for_main_lambda.name}"
  policy_arn = "${aws_iam_policy.iam_policy_for_lambda_with_sns.arn}"
}

data "aws_iam_policy_document" "lambda_publish_to_sns" {
  statement {
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = ["${aws_sns_topic.obo-sftpNotification-sns.arn}"]
  }
}

resource "aws_iam_policy" "iam_policy_for_lambda_with_sns" {
  name   = "${var.stage}-iam_policy_for_lambda_with_sns"
  path   = "/${var.service_name}/"
  policy = "${data.aws_iam_policy_document.lambda_publish_to_sns.json}"
}
