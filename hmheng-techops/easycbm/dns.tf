resource "aws_route53_record" "easycbm-wildcard" {
  zone_id = "${lookup(var.dns_zone_id, var.stage)}"
  name    = "*.easycbm"
  type    = "CNAME"
  ttl     = "300"
  records = ["easycbm${lookup(var.dns_sub_stage, var.stage)}.br.hmheng.io"]
}
