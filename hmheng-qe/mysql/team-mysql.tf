resource "aws_db_parameter_group" "parameter_group_mysql56_hmheng-qe" {
    name = "hmheng-qe-mysql-mysql56"
    family = "mysql5.6"
    description = "custom parameters for hmheng-qe team rds database instance"

    parameter {
      name = "slow_query_log"
      value = "1"
      apply_method = "pending-reboot"
    }

    parameter {
        name = "max_allowed_packet"
        value = "50000000"
        apply_method = "immediate"
    }
}

resource "aws_security_group" "hmheng-qe-mysql-sg" {
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
    Project = "hmheng-qe-mysql56"
    environment = "brnpb"
    cost = "${var.tag_cost}"
  }
}

resource "aws_db_instance" "hmheng-qe-mysql" {
  copy_tags_to_snapshot = "true"
  allocated_storage = 5
  engine = "mysql"
  instance_class = "db.t2.medium"
  name = "hmheng_qe_mysql"
  username = "hmhengqe"
  password = "${var.db-password}"
  db_subnet_group_name = "brnp-east-b"
  parameter_group_name = "${aws_db_parameter_group.parameter_group_mysql56_hmheng-qe.id}"
  vpc_security_group_ids = [
    "${aws_security_group.hmheng-qe-mysql-sg.id}"

  ]
  tags = {
    Project = "hmheng-qe-mysql56"
    environment = "brnpb"
    cost = "${var.tag_cost}"
  }
}





