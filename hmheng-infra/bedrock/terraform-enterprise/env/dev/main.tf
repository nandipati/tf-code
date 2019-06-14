module "brcoredev-infra" {
  source = "../../resources"

  elb_subnet_id      = "${element(split(",", data.terraform_remote_state.infra.subnet_core-infra02_list), 0)}"
  data_subnet_ids    = "${split("," ,data.terraform_remote_state.infra.subnet_core-infra02_list)}"
  db_password        = "RjSnprHU4YO5DFGSTfoQ3790RlNP6eb8"
  instance_subnet_id = "${element(split(",", data.terraform_remote_state.infra.subnet_core-infra02_list), 0)}"
  ami_id             = "ami-68df7217"
  region             = "us-east-1"
  bucket_name        = "${local.environment}${local.deployment_group}-tf-enterprise"
  dns_domain_name    = "${var.dns_domain_name}"
  fqdn               = "terraform.${var.dns_domain_name}"
  key_name           = "${data.terraform_remote_state.infra.keypair}"
  zone_id            = "${data.terraform_remote_state.infra.br_internal_zone_id}"
  hostname           = "terraform"
  internal_elb       = "true"
  openvpn_sg_id      = "${data.terraform_remote_state.base.openvpn_sg_id}"
  external_security_group_cidrs = "${var.external_security_group_cidrs}"

}
