module "assignment-kinesis-dev" {
  source = "./modules/assignment-kinesis/v1"

  vpc_id = "${var.vpc_id}"
  sg_cidr_bastion = "${var.sg_cidr_bastion}"
  sg_id_mesosagent = "${var.sg_id_mesosagent}"
  tag_environment = "${var.tag_environment}"
  tag_stage = "dev"
  tag_project = "${var.tag_project}"
  tag_cost = "${var.tag_cost}"
  sg_egress_protocol_all = "${var.sg_egress_protocol_all}"
  sg_egress_port_all = "${var.sg_egress_port_all}"
  sg_cidr_all = "${var.sg_cidr_all}"
  shard_count = "${lookup(var.shard_count, "dev")}"
  retention_period = "${var.retention_period}"
  aurora_role = "hmheng-core-services"
  aws_region = "us-east-1"
  app_name = "assignment-status"
}

module "assignment-kinesis-int" {
  source = "./modules/assignment-kinesis/v1"

  vpc_id = "${var.vpc_id}"
  sg_cidr_bastion = "${var.sg_cidr_bastion}"
  sg_id_mesosagent = "${var.sg_id_mesosagent}"
  tag_environment = "${var.tag_environment}"
  tag_stage = "int"
  tag_project = "${var.tag_project}"
  tag_cost = "${var.tag_cost}"
  sg_egress_protocol_all = "${var.sg_egress_protocol_all}"
  sg_egress_port_all = "${var.sg_egress_port_all}"
  sg_cidr_all = "${var.sg_cidr_all}"
  shard_count = "${lookup(var.shard_count, "int")}"
  retention_period = "${var.retention_period}"
  aurora_role = "hmheng-core-services"
  aws_region = "us-east-1"
  app_name = "assignment-status"
}