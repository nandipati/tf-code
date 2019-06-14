resource "aws_security_group" "idm-rst-ss-db-sg" {
  vpc_id = "${var.vpc_id}"
  name   = "${var.db_identifier}-${var.tag_stage}-db"

  ingress {
    from_port = "${var.db_port}"
    to_port   = "${var.db_port}"
    protocol  = "tcp"

    security_groups = [
      "${var.sg_id_jenkinsagent}",
      "${var.sg_id_mesosagent}",
      "${var.sg_id_bastion}",
    ]
  }

  tags {
    name        = "${var.db_identifier}-${var.tag_stage}-db"
    project     = "br-${var.db_identifier}-${var.tag_stage}-db"
    environment = "${lookup(var.environment, var.tag_stage)}"
    stage       = "${var.tag_stage}"
    cost        = "${var.tag_cost}"
  }
}

resource "aws_db_instance" "idm-rst-ss-db" {
  count                       = "${lookup(var.count_mysql, var.tag_stage)}"
  allocated_storage           = "${lookup(var.db_allocated_storage, var.tag_stage)}"
  identifier                  = "${var.db_identifier}-${var.tag_stage}"
  engine                      = "${var.db_engine}"
  engine_version              = "${var.db_engine_version}"
  instance_class              = "${lookup(var.db_class, var.tag_stage)}"
  name                        = "${var.db_name}"
  username                    = "${var.db_username}_${var.tag_stage}"
  password                    = "${lookup(var.db_password, var.tag_stage)}"
  apply_immediately           = true
  db_subnet_group_name        = "${var.db_subnet_group_name}"
  parameter_group_name        = "default.mysql5.7"
  backup_retention_period     = 7
  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = false

  vpc_security_group_ids = [
    "${aws_security_group.idm-rst-ss-db-sg.id}",
  ]

  tags {
    project     = "br_${var.db_identifier}-${var.tag_stage}_db"
    environment = "${lookup(var.environment, var.tag_stage)}"
    stage       = "${var.tag_stage}"
    cost        = "${var.tag_cost}"
  }
}

##############Aurora Configuration################################

resource "aws_rds_cluster" "idm-rst-ss-db-cluster" {
  count                   = "${lookup(var.count_aurora, var.tag_stage)}"
  cluster_identifier      = "idm-rst-ss-db-cluster-${var.tag_stage}"
  db_subnet_group_name    = "brnp-east-b"
  database_name           = "idm_rstr_ss_${var.tag_stage}"
  master_username         = "${lookup(var.db_aurora_username, var.tag_stage)}"
  master_password         = "${lookup(var.db_password, var.tag_stage)}"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"

  vpc_security_group_ids = [
    "${aws_security_group.idm-rst-ss-db-sg.id}",
  ]
}

resource "aws_rds_cluster_instance" "cluster-instances" {
  count              = "${lookup(var.count_aurora_instances, var.tag_stage)}"
  identifier         = "idm-rst-ss-db-cluster-${var.tag_stage}-${count.index}"
  cluster_identifier = "${aws_rds_cluster.idm-rst-ss-db-cluster.id}"
  instance_class     = "${lookup(var.db_class, var.tag_stage)}"
  apply_immediately  = true

  tags = {
    project     = "br_${var.db_identifier}-${var.tag_stage}_db"
    environment = "brnpb"
    stage       = "${var.tag_stage}"
    cost        = "${var.tag_cost}"
  }
}
