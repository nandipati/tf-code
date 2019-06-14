resource "aws_iam_instance_profile" "infra_jenkins_profile" {
  name  = "content-pipeline-jenkins-slave-profile"
  roles = ["${aws_iam_role.infra_jenkins_buildslave_role.name}"]
}

resource "aws_iam_role" "infra_jenkins_buildslave_role" {
  name               = "content-pipeline-jenkins-buildslave-role"
  assume_role_policy = "${data.aws_iam_policy_document.aws_assumerole_policy.json}"
}

resource "aws_iam_policy" "jenkins_buildslave_policy" {
  name   = "content-pipeline-jenkins-buildslave-policy"
  policy = "${data.aws_iam_policy_document.infra_jenkins_buildslave_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "jenkins_buildslave" {
  role       = "${aws_iam_role.infra_jenkins_buildslave_role.name}"
  policy_arn = "${aws_iam_policy.jenkins_buildslave_policy.arn}"
}

data "aws_iam_policy_document" "aws_assumerole_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "infra_jenkins_buildslave_role_policy" {
  statement {
    sid     = "AllowJenkinsBuildRoleAssume"
    actions = ["sts:AssumeRole"]

    resources = [
      "arn:aws:iam::${var.hmh_content_non_prod_account_number}:role/content-pipeline-dev_crossaccount",
      "arn:aws:iam::${var.hmh_content_non_prod_account_number}:role/content-pipeline-int_crossaccount",
      "arn:aws:iam::${var.hmh_content_non_prod_account_number}:role/content-pipeline-cert_crossaccount"
    ]
  }

  statement {
    sid       = "AllowJenkinsS3BucketAccess"
    actions   = ["s3:*"]
    resources = [
      "arn:aws:s3:::hmh-content-non-prod",
      "arn:aws:s3:::hmh-content-non-prod-backup"
    ]
  }
}

output "infra_jenkins_role_arn" {
  value = "${aws_iam_role.infra_jenkins_buildslave_role.arn}"
}

output "infra_jenkins_profile_arn" {
  value = "${aws_iam_instance_profile.infra_jenkins_profile.arn}"
}
