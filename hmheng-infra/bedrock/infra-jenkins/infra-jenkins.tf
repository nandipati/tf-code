resource "aws_iam_instance_profile" "infra_jenkins_profile" {
  name  = "infra-jenkins-slave-profile"
  roles = ["${aws_iam_role.infra_jenkins_buildslave_role.name}"]
}

resource "aws_iam_role" "infra_jenkins_buildslave_role" {
  name               = "infra-jenkins-buildslave-role"
  assume_role_policy = "${data.aws_iam_policy_document.aws_assumerole_policy.json}"
}

resource "aws_iam_policy" "jenkins_buildslave_policy" {
  name   = "infra-jenkins-buildslave-policy"
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
    actions = ["sts:AssumeToken"]

    resources = [
      "arn:aws:iam::${var.br_aws_account_number}:role/brnpa-btf",
      "arn:aws:iam::${var.br_aws_account_number}:role/brnpb-btf",
      "arn:aws:iam::${var.br_aws_account_number}:role/brcore01_jenkins_build",
      "arn:aws:iam::${var.br_aws_account_number}:role/brcoredev_jenkins_build",
      "arn:aws:iam::${var.br_aws_account_number}:role/brclusterdev-btf",
    ]
  }

  statement {
    sid       = "AllowDescribeInstances"
    actions   = ["ec2:DescribeInstances"]
    resources = ["*"]
  }
}

output "infra_jenkins_role_arn" {
  value = "${aws_iam_role.infra_jenkins_buildslave_role.arn}"
}

output "infra_jenkins_profile_arn" {
  value = "${aws_iam_instance_profile.infra_jenkins_profile.arn}"
}
