resource "aws_iam_user" "terraform_user" {
  name = "terraform-${var.role}"
  path = "/terraform-enterprise/"

  force_destroy = false
}
