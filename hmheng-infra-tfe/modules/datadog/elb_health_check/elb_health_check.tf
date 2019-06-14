resource "datadog_monitor" "elb_health_check" {
  name               = "bedrock::CRITICAL: ELB is Unhealthy -> ${var.elb_name}"
  type               = "metric alert"
  message            = <<EOD
**ALERT**  
Elastic Load Balancer (ELB) is Not Healthy

**ELB INFO**  
elb-name:  {{name}}  
app-name: {{elb-app-name}}  
app-stage: {{elb-app-stage}}  
aurora-role: {{elb-app-role}}  
environment: {{environment}}


***IMPORTANT:  Once issue is resolved, please log in to Datadog console and resolve the alert***

--  
@slack-bedrock-alerts ${join(" ", var.contacts)}
EOD

  escalation_message = <<EOD
**ALERT**  
Elastic Load Balancer (ELB) is still Not Healthy - PLEASE FIX NOW

**ELB INFO**  
elb-name:  {{name}}  
app-name: {{elb-app-name}}  
app-stage: {{elb-app-stage}}  
aurora-role: {{elb-app-role}}  
environment: {{environment}}  


***IMPORTANT:  Once issue is resolved, please log in to Datadog console and resolve the alert***

--  
@slack-bedrock-alerts ${join(" ", var.contacts)}
EOD

  query = "min(last_${var.monitor_window}m):avg:aws.elb.un_healthy_host_count{environment:${var.environment},name:${var.elb_name}} >= ${var.unhealthy_host_count}",

  thresholds = {
    critical = "${var.unhealthy_host_count}"
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
    "component:${var.elb_name}"
  ]
  silenced  = "${var.silenced}"
}
