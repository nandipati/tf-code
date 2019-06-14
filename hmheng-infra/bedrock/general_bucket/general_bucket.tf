resource "aws_s3_bucket" "hmheng-infra" {
  bucket = "hmheng-infra"
  acl    = "private"
  force_destroy = false
  versioning {
    enabled = false
  }
  tags {
    cost = "${var.tag_cost}"
    responsible_party = "${var.tag_cost}"
  }
}

resource "aws_s3_bucket_object" "load-testing" {
  bucket = "${aws_s3_bucket.hmheng-infra.id}"
  acl    = "private"
  key    = "load-testing/"
  source = "/dev/null"
}
