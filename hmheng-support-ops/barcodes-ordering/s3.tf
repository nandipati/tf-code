resource "aws_s3_bucket" "support-ops-s3-bucket" {
  bucket = "${var.aurora_role}"
  region = "${var.aws_region}"
  acl    = "private"

  tags {
    Name              = "${var.aurora_role}-s3-bucket"
    cost              = "${var.cost}"
    responsible-party = "${var.contact}"
  }
}

data "aws_iam_policy_document" "s3-iam-role-policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.br_aws_account_number}:root"]
    }
  }
}

resource "aws_iam_role" "s3-iam-role" {
  name               = "${var.service_name}-iam-s3-role-${var.stage}"
  path               = "/${var.service_name}/"
  assume_role_policy = "${data.aws_iam_policy_document.s3-iam-role-policy.json}"
}

data "aws_iam_policy_document" "s3-rw-role" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.support-ops-s3-bucket.arn}"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.support-ops-s3-bucket.arn}"]
  }

  statement {
    effect = "Allow"

    actions = ["s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = ["${aws_s3_bucket.support-ops-s3-bucket.arn}/*"]
  }
}

resource "aws_iam_role_policy" "s3-iam-policy" {
  name   = "s3-rw-role"
  role   = "${aws_iam_role.s3-iam-role.id}"
  policy = "${data.aws_iam_policy_document.s3-rw-role.json}"
}

# Upload the PDF template form to S3
resource "aws_s3_bucket_object" "pdf-template" {
  bucket = "${aws_s3_bucket.support-ops-s3-bucket.bucket}"
  key    = "${var.app_name}/blank_pdf_forms/Barcode_Order_Form.pdf"
  source = "Barcode_Order_Form.pdf"
  etag   = "${md5(file("Barcode_Order_Form.pdf"))}"
}
