resource "aws_iam_server_certificate" "easycbm_application" {
  name              = "${var.bedrock_role}_easycbm-application_${var.stage}"
  certificate_body  = "${file("ssl/easycbm_${var.stage}.public.pem")}"
  private_key       = "${file("ssl/easycbm_${var.stage}.private.pem")}"
  certificate_chain = "${file("ssl/easycbm_${var.stage}.intermediate.pem")}"
  count             = "${lookup(var.custom_ssl_cert_enabled, var.stage)}"

  lifecycle {
    create_before_destroy = true
  }
}
