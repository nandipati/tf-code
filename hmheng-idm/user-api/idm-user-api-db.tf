resource "aws_db_parameter_group" "parameter_group_mysql56_user" {
    name = "idm-user-api-${var.tag_stage}-mysql56"
    family = "mysql5.6"
    description = "custom parameters for idm user api mysql56 rds database instance"

    parameter {
      name = "slow_query_log"
      value = "1"
      apply_method = "pending-reboot"
    }
}

resource "aws_security_group" "idm-user-api-mysql-sg" {
  vpc_id = "vpc-e477f680"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [
      "${split(";",var.sg_cidr_bastion)}",
      "${split(";",var.sg_cidr_internal_subnets)}",
    ]
    security_groups = [
      "${var.sg_id_jenkinsagent}",
      "${var.sg_id_mesosagent}"
    ]
  }

  tags {
    Project = "idm-user-api"
    environment = "brnpb"
    stage = "${var.tag_stage}"
    cost = "${var.tag_cost}"
  }
}

resource "aws_db_instance" "idm-user-api-db" {
  count                 = "${lookup(var.count_rds, var.tag_stage)}"
  identifier            = "idm-user-api-db-${var.tag_stage}"
  allocated_storage     = 5
  engine                = "mysql"
  instance_class        = "${lookup(var.instance_class, var.tag_stage)}"
  name                  = "idm_user_api_${var.tag_stage}"
  username              = "idm_user_api"
  password              = "${lookup(var.db-pwd, var.tag_stage)}"
  db_subnet_group_name  = "brnp-east-b"
  parameter_group_name  = "${aws_db_parameter_group.parameter_group_mysql56_user.id}"
  copy_tags_to_snapshot = true
  apply_immediately     = true
  vpc_security_group_ids = [
    "${aws_security_group.idm-user-api-mysql-sg.id}"
  ]
  tags = {
    Project = "idm-user-api"
    environment = "brnpb"
    stage = "${var.tag_stage}"
    cost = "${var.tag_cost}"
  }
}

resource "aws_rds_cluster" "idm-user-api-cluster" {
    count                   = "${lookup(var.count_aurora, var.tag_stage)}"
    cluster_identifier      = "idm-user-api-cluster-${var.tag_stage}"
    db_subnet_group_name    = "brnp-east-b"
    database_name           = "idm_user_api_${var.tag_stage}"
    master_username         = "idm_user_api"
    master_password         = "${lookup(var.db-pwd, var.tag_stage)}"
    backup_retention_period = 5
    preferred_backup_window = "07:00-09:00"
    vpc_security_group_ids  = [
    "${aws_security_group.idm-user-api-mysql-sg.id}"
  ]
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count               = "${lookup(var.count_aurora_replicas, var.tag_stage)}"
  identifier          = "idm-user-api-cluster-${var.tag_stage}-${count.index}"
  cluster_identifier  = "${aws_rds_cluster.idm-user-api-cluster.id}"
  instance_class      = "${lookup(var.instance_class, var.tag_stage)}"

  tags = {
    Project     = "idm-user-api"
    environment = "brnpb"
    stage       = "${var.tag_stage}"
    cost        = "${var.tag_cost}"
  }
}
