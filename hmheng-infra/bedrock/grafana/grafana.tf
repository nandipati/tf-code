resource "aws_db_instance" "grafana-rds" {
  username   = "grafana"
  password   = "o6p31XMzKkVNxd"
  identifier = "grafana"

  engine                      = "postgres"
  engine_version              = "9.4.9"
  option_group_name           = "default:postgres-9-4"
  parameter_group_name        = "default.postgres9.4"
  auto_minor_version_upgrade  = false
  allow_major_version_upgrade = false

  instance_class          = "db.t2.medium"
  allocated_storage       = "25"
  backup_retention_period = "10"
  backup_window           = "04:30-05:30"
  maintenance_window      = "tue:05:30-tue:06:30"

  port                   = 5432
  db_subnet_group_name   = "brnp-east-b"
  multi_az               = true
  vpc_security_group_ids = ["${aws_security_group.grafana-rds.id}"]

  tags {
    cost              = "grafana"
    cost-center       = "CTGT6160"
    environment       = "brnpb"
    responsible-party = "rsarch@hmhco.com"
    salt-master       = "salt.brnpb.internal"
    stack-name        = "brnpb-grafanaDB"
  }
}

resource "aws_security_group" "grafana-rds" {
  description = "SecurityGroup for Internal Application Instances"
  vpc_id      = "vpc-e477f680"                                     // brnpb

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = [
      "10.32.112.0/28",
      "10.32.116.0/28",
      "10.32.120.0/28",
    ]

    security_groups = [
      "sg-15bcf664", // brcore01-openvpn_as
      "sg-ed73068b", // brnp-mesos
    ] // brnp.mesos
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    cost              = "grafana"
    cost-center       = "CTGT6160"
    environment       = "brnpb"
    responsible-party = "rsarch@hmhco.com"
    salt-master       = "salt.brnpb.internal"
    stack-name        = "brnpb-grafanaDB"
  }
}
