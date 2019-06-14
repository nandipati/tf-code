resource "aws_security_group" "hmheng-proficiency-band-db-sg" {
  vpc_id = "${var.vpc_id}"
  name   = "${var.db_identifier}-${var.stage}-db"

  tags {
    Name        = "${var.db_identifier}-${var.stage}-db"
    Project     = "br-${var.db_identifier}-${var.stage}-db"
    environment = "${var.tag_environment}"
    stage       = "${var.stage}"
    cost        = "${var.tag_cost}"
  }
}

resource "aws_security_group_rule" "ingress_cidr" {
  type = "ingress"

  from_port         = "${var.db_port}"
  to_port           = "${var.db_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${split(";",var.sg_cidr_bastion)}"]
  security_group_id = "${aws_security_group.hmheng-proficiency-band-db-sg.id}"
}

resource "aws_security_group_rule" "ingress_sg" {
  type = "ingress"

  from_port                = "${var.db_port}"
  to_port                  = "${var.db_port}"
  protocol                 = "tcp"
  source_security_group_id = "${var.sg_id_mesosagent}"
  security_group_id        = "${aws_security_group.hmheng-proficiency-band-db-sg.id}"
}

resource "aws_security_group_rule" "egress" {
  type = "egress"

  from_port         = "${var.sg_egress_port_all}"
  to_port           = "${var.sg_egress_port_all}"
  protocol          = "${var.sg_egress_protocol_all}"
  cidr_blocks       = ["${var.sg_cidr_all}"]
  security_group_id = "${aws_security_group.hmheng-proficiency-band-db-sg.id}"
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = "${var.aws_rds_cluster_instance_count}"
  identifier         = "${var.db_identifier}-${var.stage}-${count.index}"
  cluster_identifier = "${aws_rds_cluster.proficiency-band-api.id}"
  instance_class     = "${var.db_class}"
  engine_version     = "5.7.12"
  engine             = "${var.db_engine}"

  tags {
    Project     = "br-${var.db_identifier}-${var.stage}-db"
    environment = "${var.tag_environment}"
    stage       = "${var.stage}"
    cost        = "${var.tag_cost}"
  }
}

resource "aws_rds_cluster" "proficiency-band-api" {
  cluster_identifier   = "${var.db_identifier}-${var.stage}"
  database_name        = "${var.db_name}"
  master_username      = "${var.db_username}_${var.stage}"
  master_password      = "${var.db_password}"
  engine_version       = "5.7.12"
  engine               = "${var.db_engine}"
  port                 = "${var.db_port}"
  db_subnet_group_name = "${var.db_subnet_group_name}"

  vpc_security_group_ids = [
    "${aws_security_group.hmheng-proficiency-band-db-sg.id}",
  ]
}
