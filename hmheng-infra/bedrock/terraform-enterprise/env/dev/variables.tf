locals {
  environment                             = "brcore"
  deployment_group                        = "dev"
  name                                    = "${local.environment}${local.deployment_group}"
  tfe_org                                 = "hmhco-brts"

}

variable "dns_domain_name" {
  default = "engdev.hmhco.internal"
}

variable "external_security_group_cidrs"{
  type = "list"

  default = [
    "0.0.0.0/0",
  ]
}
