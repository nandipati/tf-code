data "aws_caller_identity" "current" {}

resource "aws_iam_user" "terraform_enterprise" {
  name = "terraform-${var.environment}${var.deployment_group}-${var.stack_name}"
  path = "/terraform-enterprise/"

  force_destroy = false
}
