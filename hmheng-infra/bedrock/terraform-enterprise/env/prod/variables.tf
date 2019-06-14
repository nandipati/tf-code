locals {
  environment                             = "brcore"
  deployment_group                        = "01"
  name                                    = "${local.environment}${local.deployment_group}"
  tfe_org                                 = "hmhco-brts"

}

variable "dns_domain_name" {
  default = "eng.hmhco.com"
}

variable "external_security_group_cidrs"{
  type = "list"

  default = [
    "0.0.0.0/0",
  ]
}
