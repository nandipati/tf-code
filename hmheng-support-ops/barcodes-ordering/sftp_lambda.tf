resource "aws_lambda_permission" "sftp_with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.obo-sftp-lambda.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.obo-sftpNotification-sns.arn}"
}

resource "aws_sns_topic_subscription" "sftp_lambda-sns-subs" {
  topic_arn = "${aws_sns_topic.obo-sftpNotification-sns.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.obo-sftp-lambda.arn}"
}

resource "aws_lambda_function" "obo-sftp-lambda" {
  function_name    = "${var.stage}-sftp_lambda_function"
  s3_bucket        = "${aws_s3_bucket.support-ops-s3-bucket.id}"
  s3_key           = "${var.app_name}/Lambdas_code/${var.stage}/sftp_lambda_function.zip"
  role             = "${aws_iam_role.iam_role_for_sftp_lambda.arn}"
  handler          = "sftp_lambda.lambda_handler"
  source_code_hash = "${base64sha256("${var.app_name}/lambdas_code/${var.stage}/sftp_lambda_function.zip")}"
  runtime          = "python2.7"
  timeout          = 90
  description      = "SFTP Lambda: zips uploaded customer files, and sftp them to RPCFTP server"

  environment {
    variables = {
      BUCKET_NAME   = "${aws_s3_bucket.support-ops-s3-bucket.id}"
      STAGE         = "${var.stage}"
      S3_APP_PATH   = "${var.app_name}/${var.stage}"
      SFTP_HOST     = "rpcftp.rpclearning.com"
      SFTP_PORT     = "22"
      SFTP_USER     = "hmhsupportopsie"
      SFTP_PASS     = "roster$7"
      SFTP_HOST_KEY = "AAAAB3NzaC1yc2EAAAABIwAAAIEAzk0D+aWCjsjpoiTOaHxR6ZzSqEOD0MRn+O5CFblRTxkVtiHWtdR+R57Qgs9kvugMzr1SsDI4xZZc4wWA4IOhMMMMHtwk1BDNNxnc+1LmspAs7vonpZClVHPxZ13OxdwdJ+XhpJ5nCvrIckW5nQCsd9tcE3NsR3MwgIY90LrPkX0="
    }
  }
}

resource "aws_iam_role" "iam_role_for_sftp_lambda" {
  name               = "${var.stage}-iam_role_for_sftp_lambda"
  path               = "/${var.service_name}/"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_execution_role.json}"
}

resource "aws_iam_role_policy_attachment" "sftp_lambda_aws_execute" {
  role       = "${aws_iam_role.iam_role_for_sftp_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_iam_role_policy_attachment" "sftp_lambda_vpc_access_execution" {
  role       = "${aws_iam_role.iam_role_for_sftp_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
