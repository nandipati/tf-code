resource "aws_security_group" "idm-ids-db-sg" {
    vpc_id = "${var.vpc_id}"
    name = "${var.db_identifier}_${var.tag_stage}_db"

    ingress {
      from_port   = "${var.db_port}"
      to_port     = "${var.db_port}"
      protocol    = "tcp"
      cidr_blocks = [ "${split(";",var.sg_cidr_bastion)}" ]
      security_groups = ["${var.sg_id_mesosagent}"]
    }

    egress {
      from_port   = "${var.sg_egress_port_all}"
      to_port     = "${var.sg_egress_port_all}"
      protocol    = "${var.sg_egress_protocol_all}"
      cidr_blocks = [ "${var.sg_cidr_all}" ]
    }

    tags {
      Name = "${var.db_identifier}_${var.tag_stage}_db"
      Project = "br_${var.db_identifier}_${var.tag_stage}_db"
      environment = "${var.tag_environment}"
      stage = "${var.tag_stage}"
      cost = "${var.tag_cost}"
    }
}

resource "aws_db_instance" "idm-ids-dev-db" {
    allocated_storage    = "${lookup(var.db_allocated_storage, var.tag_stage)}"
    identifier           = "${var.db_identifier}-${var.tag_stage}"
    engine               = "${var.db_engine}"
    engine_version       = "${var.db_engine_version}"
    instance_class       = "${lookup(var.db_class, var.tag_stage)}"
    name                 = "${var.db_name}"
    multi_az             = "${var.db_multi_az}"
    port                 = "${var.db_port}"
    username             = "${var.db_username}_${var.tag_stage}"
    password             = "${var.db_password}"
    backup_retention_period = "${lookup(var.db_backup_retention_period, var.tag_stage)}"
    backup_window = "05:00-07:00"
    apply_immediately    = true
    db_subnet_group_name = "${var.db_subnet_group_name}"
    parameter_group_name = "${lookup(var.db_parameter_group_name, var.tag_stage)}"
    allow_major_version_upgrade = true
    vpc_security_group_ids= [
      "${aws_security_group.idm-ids-db-sg.id}"
    ]

    tags {
      Project = "br_${var.db_identifier}_${var.tag_stage}_db"
      environment = "${var.tag_environment}"
      stage = "${var.tag_stage}"
      cost = "${var.tag_cost}"
    }
}
