resource "aws_s3_bucket" "hmheng-core-services-s3-bucket" {
  bucket = "${var.aurora_role}"
  region = "${var.aws_region}"
  acl    = "private"
}

resource "aws_s3_bucket_object" "assignment-status-lambda-code" {
  bucket = "${aws_s3_bucket.hmheng-core-services-s3-bucket.id}"
  key    = "${var.app_name}/lambda/assignment-lambda-0.0.9-SNAPSHOT.jar"
  source = "resources/assignment-lambda-0.0.9-SNAPSHOT.jar"
  etag   = "${md5(file("resources/assignment-lambda-0.0.9-SNAPSHOT.jar"))}"
}