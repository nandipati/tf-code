# aws - ec2 - security group
resource "aws_security_group" "hmheng-math-inventory-cache-sg" {
  vpc_id = "${var.vpc_id}"
  name   = "hmheng-math-inventory-${var.tag_stage}_cache"

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
    Name        = "hmheng-math-inventory-${var.tag_stage}_cache"
    Project     = "br_${var.cache_id}_${var.tag_stage}_cache"
    environment = "${var.tag_environment}"
    stage       = "${var.tag_stage}"
    cost        = "${var.tag_cost}"
  }
}

# aws - elasticache - redis - node
resource "aws_elasticache_cluster" "math-inventory-cache-elasticache" {
  cluster_id           = "${var.cache_id}-${var.tag_stage}"
  engine_version       = "${var.cache_engine_version}"
  engine               = "${var.cache_engine}"
  node_type            = "${var.cache_type}"
  port                 = "${var.cache_port}"
  num_cache_nodes      = "${var.cache_node_count}"
  parameter_group_name = "${var.cache_parameter_group_name}"
  subnet_group_name    = "${var.cache_subnet_group_name}"

  security_group_ids = [
    "${aws_security_group.hmheng-math-inventory-cache-sg.id}",
  ]
}

resource "aws_route53_record" "math-inventory-elasticache" {
  zone_id = "${var.zone_id}"
  name    = "math-inventory-elasticache"
  type    = "CNAME"
  ttl     = "60"
  records = ["${ aws_elasticache_cluster.math-inventory-cache-elasticache.cache_nodes.0.address }"]
}
