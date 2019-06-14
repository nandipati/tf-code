resource "aws_security_group" "codex_server_elb" {
  name        = "codex_server_elb"
  description = "allow incoming http/https traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "codex_server" {
  name    = "${var.name}"
  subnets = ["${var.ec2_elb_subnets}"]

  access_logs {
    bucket        = "${lookup(var.environment,var.stage)}-access-logs"
    bucket_prefix = "codex"
    interval      = 60
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.ssl_cert_arn}"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    target              = "TCP:80"
    interval            = 15
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  security_groups             = ["${aws_security_group.codex_server_elb.id}"]
  internal                    = true

  tags {
    Name        = "${var.name}"
    cost        = "${var.tag_cost}"
    environment = "${lookup(var.environment,var.stage)}"
    stage       = "${var.stage}"
  }
}

resource "aws_security_group" "codex_server_ec2" {
  name        = "codex_server_ec2"
  description = "allow incoming http/https traffic from elb"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.codex_server_elb.id}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.internal_subnets}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "codex_server" {
  name                 = "codex_server"
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.codex_server_ec2.id}"]
  key_name             = "awsops_rpcsys.hmhco.com"
  iam_instance_profile = "rsnp_default"
  enable_monitoring    = true

  root_block_device {
    volume_size = 40
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "codex_server" {
  vpc_zone_identifier       = ["${var.ec2_as_subnets}"]
  name                      = "codex_server_${var.stage}"
  max_size                  = "${lookup(var.as_ec2_size,"max")}"
  min_size                  = "${lookup(var.as_ec2_size,"min")}"
  health_check_grace_period = 120
  health_check_type         = "ELB"
  desired_capacity          = "${lookup(var.as_ec2_size,"desired")}"
  force_delete              = false
  launch_configuration      = "${aws_launch_configuration.codex_server.name}"
  load_balancers            = ["${aws_elb.codex_server.name}"]

  tag {
    key                 = "Name"
    value               = "${var.name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "cost"
    value               = "${var.tag_cost}"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = "${lookup(var.environment,var.stage)}"
    propagate_at_launch = true
  }

  tag {
    key                 = "stage"
    value               = "${var.stage}"
    propagate_at_launch = true
  }
}
