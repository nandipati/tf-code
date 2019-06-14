resource "aws_security_group" "content-pipeline-db-sg" {
  vpc_id = "${var.vpc_id}"
  name   = "${var.db_identifier}_${var.tag_stage}_db"

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
    Name        = "${var.db_identifier}_${var.tag_stage}_db"
    Project     = "br_${var.db_identifier}_${var.tag_stage}_db"
    environment = "${var.tag_environment}"
    stage       = "${var.tag_stage}"
    cost        = "${var.tag_cost}"
  }
}

resource "aws_db_instance" "assessments-web-db" {
  allocated_storage           = "${var.db_allocated_storage[var.tag_stage]}"
  identifier                  = "${var.db_identifier}-${var.tag_stage}"
  engine                      = "${var.db_engine}"
  engine_version              = "${var.db_engine_version[var.tag_stage]}"
  instance_class              = "${var.db_class[var.tag_stage]}"
  name                        = "${var.db_name}"
  multi_az                    = "${var.db_multi_az}"
  port                        = "${var.db_port}"
  username                    = "${var.db_username}_${var.tag_stage}"
  password                    = "${var.db_password[var.tag_stage]}"
  db_subnet_group_name        = "${var.db_subnet_group_name}"
  parameter_group_name        = "${var.db_parameter_group_name[var.tag_stage]}"
  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = true

  vpc_security_group_ids = [
    "${aws_security_group.content-pipeline-db-sg.id}",
  ]

  tags {
    Project     = "br_${var.db_identifier}_${var.tag_stage}_db"
    environment = "${var.tag_environment}"
    stage       = "${var.tag_stage}"
    cost        = "${var.tag_cost}"
  }
}
