# aws - ec2 - security group
resource "aws_security_group" "support-ops-obo-cache-sg" {
  vpc_id = "${var.vpc_id}"
  name   = "${var.aurora_role}_${var.stage}_${var.service_name}_cache"

  ingress {
    from_port       = "${var.cache_port}"
    to_port         = "${var.cache_port}"
    protocol        = "tcp"
    cidr_blocks     = ["${split(";",var.sg_cidr_bastion)}"]
    security_groups = ["${var.sg_id_mesosagent}"]
  }

  egress {
    from_port   = "${var.sg_egress_port_all}"
    to_port     = "${var.sg_egress_port_all}"
    protocol    = "${var.sg_egress_protocol_all}"
    cidr_blocks = ["${var.sg_cidr_all}"]
  }

  tags {
    Name              = "${var.aurora_role}_${var.service_name}_cache_sg"
    cost              = "${var.cost}"
    responsible-party = "${var.contact}"
  }
}

# aws - elasticache - redis - node
resource "aws_elasticache_cluster" "obo-elasticache" {
  cluster_id           = "so-obo-${var.stage}-cache"
  engine_version       = "${var.cache_engine_version}"
  engine               = "${var.cache_engine}"
  node_type            = "${lookup(var.cache_type, var.stage)}"
  port                 = "${var.cache_port}"
  num_cache_nodes      = "${var.cache_node_count}"
  parameter_group_name = "${var.cache_parameter_group_name}"
  subnet_group_name    = "${var.cache_subnet_group_name}"
  security_group_ids   = ["${aws_security_group.support-ops-obo-cache-sg.id}"]

  tags {
    Name              = "support-ops-s3-bucket"
    cost              = "${var.cost}"
    responsible-party = "${var.contact}"
  }
}

resource "aws_route53_record" "obo-elasticache" {
  zone_id = "${lookup(var.dns_zone_id, var.stage)}"
  name    = "obo-${var.stage}-redis"
  type    = "CNAME"
  ttl     = "60"
  records = ["${ aws_elasticache_cluster.obo-elasticache.cache_nodes.0.address }"]
}
