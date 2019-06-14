resource "aws_security_group" "mms-securitygroup" {
  vpc_id = "${var.vpc_id}"

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
    responsible-party = "${var.tag_responsible_party}"
    stage             = "${var.tag_stage}"
    cost              = "${var.tag_project}"
  }
}

# create a MySQL instance for a lower environment
resource "aws_db_instance" "mms-mysql-db" {
  count                      = "${lookup(var.count_mysql_instances, var.tag_stage)}"
  identifier                 = "mms-db-${var.tag_stage}"
  allocated_storage          = 5
  engine                     = "mysql"
  instance_class             = "${lookup(var.instance_class, var.tag_stage)}"
  name                       = "mms_${var.tag_stage}"
  username                   = "mms"
  password                   = "${lookup(var.db-pwd, var.tag_stage)}"
  db_subnet_group_name       = "brcore01_service"
  copy_tags_to_snapshot      = true
  auto_minor_version_upgrade = false

  vpc_security_group_ids = [
    "${aws_security_group.mms-securitygroup.id}",
  ]

  tags = {
    responsible-party = "${var.tag_responsible_party}"
    stage             = "${var.tag_stage}"
    cost              = "${var.tag_project}"
  }
}

# Create an Aurora Cluster for a higher environment
resource "aws_rds_cluster" "mms-aurora-cluster" {
  count                   = "${lookup(var.count_aurora_clusters, var.tag_stage)}"
  cluster_identifier      = "mms-cluster-${var.tag_stage}"
  db_subnet_group_name    = "brcore01_service"
  database_name           = "mms_${var.tag_stage}"
  master_username         = "mms"
  master_password         = "${lookup(var.db-pwd, var.tag_stage)}"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"

  vpc_security_group_ids = [
    "${aws_security_group.mms-securitygroup.id}",
  ]
}

# Create one or more Aurora DB instances that belong to the mms-aurora-cluster
resource "aws_rds_cluster_instance" "mms-cluster-instances" {
  count                      = "${lookup(var.count_aurora_cluster_instances, var.tag_stage)}"
  identifier                 = "mms-${var.tag_stage}-${count.index}"
  cluster_identifier         = "${aws_rds_cluster.mms-aurora-cluster.id}"
  instance_class             = "${lookup(var.instance_class, var.tag_stage)}"
  auto_minor_version_upgrade = false

  tags = {
    responsible-party = "${var.tag_responsible_party}"
    stage             = "${var.tag_stage}"
    cost              = "${var.tag_project}"
  }
}
