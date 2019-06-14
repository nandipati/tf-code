resource "aws_s3_bucket" "aurora_backup_bucket" {
    bucket = "${var.vpc_abbrev}-aurora-backup"
    acl = "private"
    tags {
        Name = "${var.vpc_abbrev}-aurora-backup"
        environment = "${var.vpc_abbrev}"
        cost = "aurora"
    }
}