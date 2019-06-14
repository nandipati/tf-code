This module intends to create iam permissions for team base usage of TFE, each new team can be defined with a simple
module call example:
```
module "<my-role>" {
  source = "./modules/role"

  role        = "<my-role>"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}
```
such that <my-role> is role without hmheng prefix.

The iam user for TFE to deploy this is stored under legacy/hmheng-infra/bedrock/terraform-team-iam