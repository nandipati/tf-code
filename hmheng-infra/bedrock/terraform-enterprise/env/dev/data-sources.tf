data "terraform_remote_state" "infra" {
  backend = "atlas"

  config {
    name = "${local.tfe_org}/${local.name}-infra"
  }
}

data "terraform_remote_state" "base" {
  backend = "atlas"

  config {
    name = "${local.tfe_org}/${local.name}-base"
  }
}

data "aws_caller_identity" "current" {}
