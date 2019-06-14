resource "aws_security_group" "hmheng-customdev-chiroapi-sg" {
  vpc_id = "${var.vpc_id}"
  name   = "hmheng-customdev-chiroapi-${var.stage}"

  tags {
    Name              = "hmheng-customdev-chiroapi-${var.stage}"
    responsible-party = "${var.tag_responsible_party}"
    stage             = "${var.stage}"
    cost              = "${var.tag_project}"
  }
}

resource "aws_security_group_rule" "ingress_cidr" {
  type = "ingress"

  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  cidr_blocks = [
    "${split(";",var.sg_cidr_bastion)}",
    "${split(";",var.sg_cidr_internal_subnets)}",
  ]

  security_group_id = "${aws_security_group.hmheng-customdev-chiroapi-sg.id}"
}

resource "aws_security_group_rule" "ingress_sg" {
  type = "ingress"

  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = "${var.sg_id_mesosagent}"
  security_group_id        = "${aws_security_group.hmheng-customdev-chiroapi-sg.id}"
}

# Create MySQL database
resource "aws_db_instance" "chiroapi-mysql-db" {
  identifier                 = "hmheng-customdev-chiroapi-db-${var.stage}"
  allocated_storage          = "${var.db_allocated_storage}"
  engine                     = "mysql"
  engine_version             = "5.7.22"
  instance_class             = "${var.db_class}"
  name                       = "hmheng_customdev_chiroapi_mysql_${var.stage}"
  username                   = "${var.db_username}"
  password                   = "${var.db_password}"
  backup_retention_period    = 5
  db_subnet_group_name       = "brcore01_service"
  copy_tags_to_snapshot      = true
  auto_minor_version_upgrade = false

  vpc_security_group_ids = [
    "${aws_security_group.hmheng-customdev-chiroapi-sg.id}",
  ]

  tags = {
    responsible-party = "${var.tag_responsible_party}"
    stage             = "${var.stage}"
    cost              = "${var.tag_project}"
  }
}
