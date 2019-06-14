data "aws_iam_policy_document" "iam" {
  statement {
    sid = "iamTeamRoleManager"

    actions = [
      "iam:*",
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "iam" {
  name   = "terraform_role_manager_iam"
  policy = "${data.aws_iam_policy_document.iam.json}"
}

resource "aws_iam_user_policy_attachment" "terraform_iam" {
  user       = "${aws_iam_user.terraform_user.name}"
  policy_arn = "${aws_iam_policy.iam.arn}"
}

resource "aws_iam_user" "terraform_user" {
  name = "terraform-role-manager"
  path = "/terraform-enterprise/"

  force_destroy = false
}
