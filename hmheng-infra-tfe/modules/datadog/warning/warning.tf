resource "datadog_monitor" "datadog_warning" {
  name               = "bedrock::WARNING: ${var.name}"
  type               = "${var.type}"
  message            = "${var.message} @slack-bedrock-alerts @pagerduty-br-infra-warning"
  escalation_message = "${var.message} @slack-bedrock-alerts @pagerduty-br-infra-warning"

  query = "${var.query}"

  thresholds = "${var.thresholds}"

  notify_no_data    = "${var.notify_no_data}"
  new_host_delay    = "${var.new_host_delay}"
  evaluation_delay  = "${var.evaluation_delay}"
  no_data_timeframe = "${var.no_data_timeframe}"
  renotify_interval = "${var.renotify_interval}"

  notify_audit = "${var.notify_audit}"
  timeout_h    = "${var.timeout_h}"
  include_tags = "${var.include_tags}"

  require_full_window = "${var.require_full_window}"
  locked              = "${var.locked}"

  tags      = "${var.tags}"
  silenced  = "${var.silenced}"
}
