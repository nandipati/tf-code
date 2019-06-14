resource "aws_s3_bucket" "idm_bucket" {
  bucket = "hmheng-idm"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags {
    Name = "idm_bucket"
    cost = "idm"
  }
}
