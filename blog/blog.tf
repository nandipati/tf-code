resource "aws_security_group" "io_hmheng_br_blog-group_sg" {
  name = "${var.tag_environment}_blog_group"
  vpc_id = "${var.vpc-id}"
  tags = {
    Project = "${var.project-name}"
    environment = "brnpb"
    cost = "${var.tag_cost}"
  }
}
resource "aws_security_group" "io_hmheng_br_blog-web_sg" {
  vpc_id = "${var.vpc-id}"
  name = "${var.tag_environment}_blog_web"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.io_hmheng_br_blog-group_sg.id}"
    ]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.cidr_internal}"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.cidr_bastion}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Project = "${var.project-name}"
    environment = "brnpb"
    cost = "${var.tag_cost}"
  }
}
resource "aws_security_group" "io_hmheng_br_blog_db_sg" {
  name = "${var.tag_environment}_blog_db"
  vpc_id = "${var.vpc-id}"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.io_hmheng_br_blog-group_sg.id}"
    ]
  }
  tags = {
    Project = "${var.project-name}"
    environment = "brnpb"
    cost = "${var.tag_cost}"
  }
}

resource "aws_db_instance" "io_hmheng_br_blog_db" {
  allocated_storage    = 5
  engine               = "mysql"
  instance_class       = "${var.db-class}"
  name                 = "${var.db-name}"
  username             = "${var.db-username}"
  password             = "${var.db-password}"
  db_subnet_group_name = "${var.db_subnet-name}"
  parameter_group_name = "default.mysql5.6"
  copy_tags_to_snapshot = true
  vpc_security_group_ids = [
    "${aws_security_group.io_hmheng_br_blog_db_sg.id}"
  ]
  tags = {
    Project = "${var.project-name}"
    environment = "brnpb"
    cost = "${var.tag_cost}"
  }
}

resource "aws_instance" "io_hmheng_blog_ec2" {
  ami = "ami-3a1e2d50"
  instance_type = "t2.medium"
  key_name = "aws_bedrock_nonprod_base"
  instance_initiated_shutdown_behavior = "stop"
  disable_api_termination = true
//  user_data = "${file(\"${path.module}/user_data.sh\")}"
  vpc_security_group_ids = [
          "${aws_security_group.io_hmheng_br_blog-group_sg.id}",
          "${aws_security_group.io_hmheng_br_blog-web_sg.id}",
  ]
  subnet_id = "subnet-4c8d733a"
  tags = {
    Project = "${var.project-name}"
    salt-role = "internal.blog"
    salt-master = "salt.brnpb.internal"
    environment = "brnpb"
    lambda_task = "backup"
  }
//  depends_on = ["aws_db_instance.io_hmheng_br_blog_db"]
}


resource "aws_route53_record" "io_hmheng_br_blog" {
  zone_id = "Z2WUOZOGBH83LP"
  name = "blog.br.hmheng.io"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.io_hmheng_blog_ec2.private_ip}"]
}
