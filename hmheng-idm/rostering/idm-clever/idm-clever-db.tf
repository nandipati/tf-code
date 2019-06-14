resource "aws_db_parameter_group" "parameter_group_mysql56_int" {
  name        = "idm-clever-int-mysql56"
  family      = "mysql5.6"
  description = "custom parameters for idm clever int mysql56 rds database instance"

  parameter {
    name         = "slow_query_log"
    value        = "1"
    apply_method = "pending-reboot"
  }
}

resource "aws_security_group" "idm-clever-mysql-sg" {
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
      "${lookup(var.sg_id_ebr, "dev")}",
      "${lookup(var.sg_id_ebr, "int")}",
      "${lookup(var.sg_id_ebr, "cert")}",
    ]
  }

  tags {
    Project     = "idm-clever"
    environment = "brnpb"
    stage       = "cert,prod"
    cost        = "${var.tag_cost}"
  }
}

resource "aws_db_instance" "idm-clever-int" {
  allocated_storage    = 5
  engine               = "mysql"
  instance_class       = "db.t1.micro"
  name                 = "idm_clever_int"
  username             = "idm_clever"
  password             = "${var.db-password-int}"
  db_subnet_group_name = "brnp-east-b"
  parameter_group_name = "${aws_db_parameter_group.parameter_group_mysql56_int.id}"

  vpc_security_group_ids = [
    "${aws_security_group.idm-clever-mysql-sg.id}",
  ]

  tags = {
    Project     = "idm-clever"
    environment = "brnpb"
    stage       = "int"
    cost        = "${var.tag_cost}"
  }
}

resource "aws_rds_cluster" "idm-clever-cluster-cert" {
  cluster_identifier = "idm-clever-cluster-cert"

  db_subnet_group_name    = "brnp-east-b"
  database_name           = "idm_clever_cert"
  master_username         = "idm_clever"
  master_password         = "${var.db-password-cert}"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = false

  vpc_security_group_ids = [
    "${aws_security_group.idm-clever-mysql-sg.id}",
  ]
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "idm-clever-cluster-cert-${count.index}"
  cluster_identifier = "${aws_rds_cluster.idm-clever-cluster-cert.id}"
  instance_class     = "db.r4.2xlarge"
  promotion_tier     = 1
  apply_immediately  = true

  tags = {
    Project     = "idm-clever"
    environment = "brnpb"
    stage       = "cert"
    cost        = "${var.tag_cost}"
  }
}

resource "aws_rds_cluster" "idm-clever-cluster-prod" {
  cluster_identifier = "idm-clever-cluster-prod"

  db_subnet_group_name    = "brnp-east-b"
  database_name           = "idm_clever_prod"
  master_username         = "idm_clever"
  master_password         = "${var.db-password-prod}"
  backup_retention_period = 5
  skip_final_snapshot     = false
  preferred_backup_window = "07:00-09:00"

  vpc_security_group_ids = [
    "${aws_security_group.idm-clever-mysql-sg.id}",
  ]
}

resource "aws_rds_cluster_instance" "cluster_instances_prod" {
  count              = 3
  identifier         = "idm-clever-cluster-prod-${count.index}"
  cluster_identifier = "${aws_rds_cluster.idm-clever-cluster-prod.id}"
  instance_class     = "db.r4.2xlarge"
  promotion_tier     = 1
  apply_immediately  = true

  tags = {
    Project     = "idm-clever"
    environment = "brnpb"
    stage       = "prod"
    cost        = "${var.tag_cost}"
  }
}
