resource "aws_security_group" "hmheng-qe-sonarqube-server-db-sg" {
  vpc_id = "${var.vpc_id}"
  name   = "${var.db_identifier}_${var.stage}_db"

  ingress {
    from_port       = "${var.db_port}"
    to_port         = "${var.db_port}"
    protocol        = "tcp"
    cidr_blocks     = ["${split(";",var.sg_cidr_bastion)}"]
    security_groups = ["${var.sg_id_mesosagent}"]
  }

  egress {
    from_port   = "${var.sg_egress_port_all}"
    to_port     = "${var.sg_egress_port_all}"
    protocol    = "${var.sg_egress_protocol_all}"
    cidr_blocks = ["${var.sg_cidr_all}"]
  }

  tags {
    Name        = "${var.db_identifier}_${var.stage}_db"
    Project     = "br_${var.db_identifier}_${var.stage}_db"
    environment = "${var.tag_environment}"
    stage       = "${var.stage}"
    cost        = "${var.tag_cost}"
  }
}

resource "aws_db_parameter_group" "hmheng-qe-sonarqube-server-params" {
  name   = "${var.db_identifier}-${var.stage}-params"
  family = "${var.db_parameter_group_family}"

  parameter {
    name  = "max_allowed_packet"
    value = "${var.max_allowed_packet}"
  }

  parameter {
    name  = "slow_query_log"
    value = "${var.slow_query_log}"
  }


}

resource "aws_db_instance" "hmheng-qe-sonarqube-db" {
  allocated_storage           = "${var.db_allocated_storage}"
  identifier                  = "${var.db_identifier}-${var.stage}"
  engine                      = "${var.db_engine}"
  instance_class              = "${var.db_class}"
  name                        = "${var.db_name}"
  multi_az                    = "${var.db_multi_az}"
  port                        = "${var.db_port}"
  final_snapshot_identifier   = "${var.db_identifier}-${var.stage}"
  username                    = "${var.db_username}"
  password                    = "${var.db_password}"
  db_subnet_group_name        = "${var.db_subnet_group_name}"
  backup_retention_period     = "${var.db_backup_retention_period}"
  parameter_group_name        = "${aws_db_parameter_group.hmheng-qe-sonarqube-server-params.id}"
  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = true

  vpc_security_group_ids = [
    "${aws_security_group.hmheng-qe-sonarqube-server-db-sg.id}",
  ]

  tags {
    Project     = "br_${var.db_identifier}_${var.stage}_db"
    environment = "${var.tag_environment}"
    stage       = "${var.stage}"
    cost        = "${var.tag_cost}"
  }
}

