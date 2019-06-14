resource "aws_db_parameter_group" "parameter_group_mysql57_user" {
  name        = "dmps-${var.tag_stage}-mysql57"
  family      = "mysql5.7"
  description = "custom parameters for dmps mysql57 rds database instance"

  parameter {
    name         = "slow_query_log"
    value        = "1"
    apply_method = "pending-reboot"
  }
}

resource "aws_security_group" "dmps-mysql-sg" {
  vpc_id = "vpc-e477f680"

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    cidr_blocks = [
      "${split(";",var.sg_cidr_bastion)}",
      "${split(";",var.sg_cidr_internal_subnets)}",
    ]

    security_groups = [
      "${var.sg_id_jenkinsagent}",
      "${var.sg_id_mesosagent}",
    ]
  }

  tags {
    Project     = "dmps"
    environment = "brnpb"
    stage       = "${var.tag_stage}"
    cost        = "${var.tag_cost}"
  }
}

resource "aws_db_instance" "dmps-db" {
  identifier                 = "dmps-db-${var.tag_stage}"
  allocated_storage          = "${lookup(var.storage_by_stage, var.tag_stage)}"
  auto_minor_version_upgrade = false                                                       # Set as directed by http://doc-server.prod.hmheng-infra.brnp.internal/src/guide/using-aws-resources.html#general-guidelines
  engine                     = "mysql"
  engine_version             = "5.7.17"
  instance_class             = "${lookup(var.instance_class_by_stage, var.tag_stage)}"
  multi_az                   = "${lookup(var.multi_az_by_stage, var.tag_stage)}"
  name                       = "dmps_${var.tag_stage}"
  username                   = "dmps_user"
  password                   = "${lookup(var.db-pwd, var.tag_stage)}"
  db_subnet_group_name       = "brnp-east-b"
  parameter_group_name       = "${aws_db_parameter_group.parameter_group_mysql57_user.id}"
  copy_tags_to_snapshot      = true
  backup_retention_period    = "7"
  backup_window              = "07:00-09:00"
  apply_immediately          = true
  vpc_security_group_ids = [
    "${aws_security_group.dmps-mysql-sg.id}",
  ]

  tags = {
    Project     = "dmps"
    environment = "brnpb"
    stage       = "${var.tag_stage}"
    cost        = "${var.tag_cost}"
  }
}

resource "aws_db_instance" "dmps-db-read-replica" {
  count                      = "${lookup(var.read_replicas_by_stage, var.tag_stage)}"
  identifier                 = "dmps-db-${var.tag_stage}-rr-${count.index}"
  auto_minor_version_upgrade = false
  instance_class             = "${lookup(var.instance_class_by_stage, var.tag_stage)}"
  multi_az                   = "${lookup(var.multi_az_by_stage, var.tag_stage)}"
  name                       = "dmps_${var.tag_stage}"
  parameter_group_name       = "${aws_db_parameter_group.parameter_group_mysql57_user.id}"
  copy_tags_to_snapshot      = true
  replicate_source_db        = "${aws_db_instance.dmps-db.identifier}"

  vpc_security_group_ids = [
    "${aws_security_group.dmps-mysql-sg.id}",
  ]

  tags = {
    Project     = "dmps"
    environment = "brnpb"
    stage       = "${var.tag_stage}"
    cost        = "${var.tag_cost}"
  }
}
