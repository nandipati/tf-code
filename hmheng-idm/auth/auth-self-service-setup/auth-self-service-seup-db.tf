resource "aws_security_group" "auth-self-service-setup-securitygroup" {
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = "${var.db_port}"
    to_port   = "${var.db_port}"
    protocol  = "${var.db_protocol}"

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
    Project     = "br_${var.db_identifier}_${var.tag_stage}_db"
    environment = "${var.tag_environment}"
    stage       = "${var.tag_stage}"
    cost        = "${var.tag_cost}"
  }
}

# Configure DB to be UTF-8
resource "aws_db_parameter_group" "dbpg" {
  name   = "${var.parameter_group_name}-${var.tag_stage}"
  family = "${lookup(var.family, var.tag_stage)}"
  count  = "${lookup(var.count_mysql_instances, var.tag_stage)}"

  parameter {
    name  = "character_set_client"
    value = "${var.char_set_full}"
  }

  parameter {
    name  = "character_set_connection"
    value = "${var.char_set_full}"
  }

  parameter {
    name  = "character_set_database"
    value = "${var.char_set_full}"
  }

  parameter {
    name  = "character_set_results"
    value = "${var.char_set_full}"
  }

  parameter {
    name  = "character_set_server"
    value = "${var.char_set_full}"
  }

  parameter {
    name  = "collation_connection"
    value = "${var.collation_value}"
  }

  parameter {
    name  = "collation_server"
    value = "${var.collation_value}"
  }
}

# Configure DB Cluster to be UTF-8
resource "aws_rds_cluster_parameter_group" "dbcpg" {
  name   = "${var.parameter_cluster_group_name}-${var.tag_stage}"
  family = "${lookup(var.family, var.tag_stage)}"
  count  = "${lookup(var.count_aurora_clusters, var.tag_stage)}"

  parameter {
    name  = "character_set_client"
    value = "${var.char_set_full}"
  }

  parameter {
    name  = "character_set_connection"
    value = "${var.char_set_full}"
  }

  parameter {
    name  = "character_set_database"
    value = "${var.char_set_full}"
  }

  parameter {
    name  = "character_set_results"
    value = "${var.char_set_full}"
  }

  parameter {
    name  = "character_set_server"
    value = "${var.char_set_full}"
  }

  parameter {
    name  = "collation_connection"
    value = "${var.collation_value}"
  }

  parameter {
    name  = "collation_server"
    value = "${var.collation_value}"
  }
}

# create a MySQL instance for a lower environment
resource "aws_db_instance" "auth-self-service-setup-mysql-db" {
  count                       = "${lookup(var.count_mysql_instances, var.tag_stage)}"
  identifier                  = "${var.db_identifier}-${var.tag_stage}"
  allocated_storage           = "${var.db_allocated_storage}"
  engine                      = "${var.db_engine}"
  instance_class              = "${lookup(var.instance_class, var.tag_stage)}"
  name                        = "${var.db_name}_${var.tag_stage}"
  username                    = "${var.db_username}"
  password                    = "${lookup(var.db_pwd, var.tag_stage)}"
  db_subnet_group_name        = "${var.db_subnet_group_name}"
  parameter_group_name        = "${aws_db_parameter_group.dbpg.id}"
  allow_major_version_upgrade = true
  apply_immediately           = true

  vpc_security_group_ids = [
    "${aws_security_group.auth-self-service-setup-securitygroup.id}",
  ]

  tags {
    Project     = "br_${var.db_identifier}_${var.tag_stage}_db"
    environment = "${var.tag_environment}"
    stage       = "${var.tag_stage}"
    cost        = "${var.tag_cost}"
  }
}

# Create an Aurora Cluster for a higher environment
resource "aws_rds_cluster" "auth-self-service-setup-aurora-cluster" {
  count                           = "${lookup(var.count_aurora_clusters, var.tag_stage)}"
  cluster_identifier              = "${var.db_identifier}-cluster-${var.tag_stage}"
  db_subnet_group_name            = "${var.db_subnet_group_name}"
  database_name                   = "${var.db_name}_${var.tag_stage}"
  master_username                 = "${var.db_username}"
  master_password                 = "${lookup(var.db_pwd, var.tag_stage)}"
  backup_retention_period         = "${var.backup_retention_period}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.dbcpg.id}"
  preferred_backup_window         = "02:00-09:00"

  vpc_security_group_ids = [
    "${aws_security_group.auth-self-service-setup-securitygroup.id}",
  ]
}

# Create one or more Aurora DB instances that belong to the auth-self-service-setup aurora cluster
resource "aws_rds_cluster_instance" "auth-self-service-setup-cluster-instances" {
  count              = "${lookup(var.count_aurora_cluster_instances, var.tag_stage)}"
  identifier         = "auth-self-service-setup-${var.tag_stage}-${count.index}"
  cluster_identifier = "${aws_rds_cluster.auth-self-service-setup-aurora-cluster.id}"
  instance_class     = "${lookup(var.instance_class, var.tag_stage)}"
  apply_immediately  = true

  tags {
    Project     = "br_${var.db_identifier}_${var.tag_stage}_db"
    environment = "${var.tag_environment}"
    stage       = "${var.tag_stage}"
    cost        = "${var.tag_cost}"
  }
}
