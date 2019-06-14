module "demo" {
  source      = "./modules/role"
  role        = "demo"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "idm" {
  source      = "./modules/role"
  role        = "idm"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "cds" {
  source      = "./modules/role"
  role        = "cds"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "report" {
  source = "./modules/role"

  role        = "report"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "scoring" {
  source = "./modules/role"

  role        = "scoring"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "core-services" {
  source      = "./modules/role"
  role        = "core-services"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "clm" {
  source      = "./modules/role"
  role        = "clm"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "support-ops" {
  source      = "./modules/role"
  role        = "support-ops"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "assignments" {
  source      = "./modules/role"
  role        = "assignments"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "content-pipeline" {
  source      = "./modules/role"
  role        = "content-pipeline"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "techops" {
  source      = "./modules/role"
  role        = "techops"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "rce" {
  source      = "./modules/role"
  role        = "rce"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "isg" {
  source      = "./modules/role"
  role        = "isg"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "arch" {
  source      = "./modules/role"
  role        = "arch"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "release" {
  source      = "./modules/role"
  role        = "release"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "curiousworld" {
  source      = "./modules/role"
  role        = "curiousworld"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "ds" {
  source      = "./modules/role"
  role        = "ds"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "qe" {
  source      = "./modules/role"
  role        = "qe"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "dmps" {
  source      = "./modules/role"
  role        = "dmps"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "ngss" {
  source      = "./modules/role"
  role        = "ngss"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "data-framework" {
  source      = "./modules/role"
  role        = "data-framework"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "customdev" {
  source      = "./modules/role"
  role        = "customdev"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "datascience" {
  source      = "./modules/role"
  role        = "datascience"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "assessments" {
  source      = "./modules/role"
  role        = "assessments"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "csl" {
  source      = "./modules/role"
  role        = "csl"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "math-inventory" {
  source      = "./modules/role"
  role        = "math-inventory"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "ch" {
  source      = "./modules/role"
  role        = "ch"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "reading-inventory" {
  source = "./modules/role"

  role        = "reading-inventory"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "sis-curiosity" {
  source      = "./modules/role"
  role        = "sis-curiosity"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "pou" {
  source      = "./modules/role"
  role        = "pou"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "proficiency-band-service" {
  source      = "./modules/role"
  role        = "proficiency-band-service"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}

module "partner-service" {
  source      = "./modules/role"
  role        = "partner-service"
  core_vpc_id = "${var.core_vpc_id}"
  aws_region  = "us-east-1"
}
