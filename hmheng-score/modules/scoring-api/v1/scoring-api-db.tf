resource "aws_security_group" "hmheng-score-scoring-api-db-sg" {
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

resource "aws_db_parameter_group" "hmheng-score-ccas-new-wal-params" {
  name   = "${var.db_identifier}-${var.stage}-new-wal-params"
  family = "${var.db_parameter_group_family}"

  parameter {
    name  = "max_wal_senders"
    value = "${var.db_parameter_max_wal_senders}"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "max_standby_streaming_delay"
    value = "${var.db_parameter_max_standby_streaming_delay}"
    apply_method = "pending-reboot"

  }

  parameter {
      name  = "statement_timeout"
      value = "${var.db_parameter_statement_timeout}"
      apply_method = "pending-reboot"

  }
}

resource "aws_db_instance" "hmheng-score-scoring-db" {
  allocated_storage           = "${var.db_allocated_storage}"
  identifier                  = "${var.db_identifier}-${var.stage}"
  engine                      = "${var.db_engine}"
  engine_version              = "${var.db_engine_version}"
  instance_class              = "${var.db_class}"
  name                        = "${var.db_name}"
  multi_az                    = "${var.db_multi_az}"
  port                        = "${var.db_port}"
  username                    = "${var.db_username}"
  password                    = "${var.db_password}"
  db_subnet_group_name        = "${var.db_subnet_group_name}"
  backup_retention_period     = "${var.db_backup_retention_period}"
  parameter_group_name        = "${aws_db_parameter_group.hmheng-score-ccas-new-wal-params.id}"
  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = "${var.db_auto_minor_version_upgrade}"
  apply_immediately           = true
  snapshot_identifier         = "${var.db_create_from_snapshot}"

  vpc_security_group_ids = [
    "${aws_security_group.hmheng-score-scoring-api-db-sg.id}",
  ]

  tags {
    Project     = "br_${var.db_identifier}_${var.stage}_db"
    environment = "${var.tag_environment}"
    stage       = "${var.stage}"
    cost        = "${var.tag_cost}"
  }
}
