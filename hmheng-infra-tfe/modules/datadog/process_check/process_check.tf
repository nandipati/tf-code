resource "datadog_monitor" "process_check" {
  name    = "bedrock::CRITICAL: Process is NOT Running -> ${var.process_name}"
  type    = "service check"
  message = "@slack-bedrock-alerts\n\n{{host.ip}} \n{{host.salt-role}} \n{{host.environment}} @pagerduty-br-infra-warning"
  query   = "\"process.up\".over(\"process:${var.process_name}\",\"salt-master:salt.brcore01.internal\").by(\"host\",\"process\").last(${max(var.ok_threshold, var.warning_threshold, var.critical_threshold) + 1}).count_by_status()"

  thresholds = {
    ok       = "${var.ok_threshold}"
    warning  = "${var.warning_threshold}"
    critical = "${var.critical_threshold}"
  }

  notify_no_data    = "${var.notify_no_data}"
  new_host_delay    = 600
  evaluation_delay  = "${var.evaluation_delay}"
  no_data_timeframe = "${var.no_data_timeframe}"
  renotify_interval = "${var.renotify_interval}"

  notify_audit = "${var.notify_audit}"
  timeout_h    = "${var.timeout_h}"
  include_tags = "${var.include_tags}"

  require_full_window = "${var.require_full_window}"
  locked              = "${var.locked}"

  tags      = [
    "service:bedrock",
    "process",
    "component:${var.process_name}"
  ]
  silenced  = "${var.silenced}"
}
