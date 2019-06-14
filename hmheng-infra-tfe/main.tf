provider "datadog" {
  api_key = "${var.datadog_api_key}"
  app_key = "${var.datadog_app_key}"
}

module "iam-key-checker-warning" {
  source = "modules/datadog/warning/"

  name = "IAM Key Checker found old keys"
  type = "event alert"
  message = "{{event.text}}"
  query = "events('priority:all status:warning excluded_tags:bedrock_jenkins \"iam-key-checker\"').rollup('count').last('1d') >= 1"
}

module "linkerd-fd-count-warning" {
  source = "modules/datadog/warning/"

  name = "Linkerd open file descriptor count is high"
  type = "metric alert"
  message = "open file descriptor count on linkerd process is high"
  query = "avg(last_5m):avg:linkerd.jvm.fd_count{*} by {host} > 40000"
}


module "linkerd-fd-count-critical" {
  source = "modules/datadog/critical/"

  name = "Linkerd open file descriptor count is very high"
  type = "metric alert"
  message = "open file descriptor count on linkerd process is very high"
  query = "avg(last_5m):avg:linkerd.jvm.fd_count{*} by {host} > 50000"
}

module "jenkins-slave-count-warning" {
  source = "modules/datadog/warning/"

  name = "Number of team Jenkins instances high"
  type = "metric alert"
  message = "ec2 instances with tag \"name: jenkins-build-slave-spot\" is exceeding 25"
  query = "avg(last_30m):sum:aws.ec2.host_ok{name:jenkins-build-slave-spot} > 25"
}

module "inode-count-warning" {
  source = "modules/datadog/warning/"

  name = "Total inodes usage is high"
  type = "metric alert"
  message = "Host: {{host.ip}} \nrole: {{host.salt-role}} \n\nThe number of inodes in use as exceeds 75%"
  query = "avg(last_5m):avg:system.fs.inodes.in_use{*} > 75"
}


module "inode-count-critical" {
  source = "modules/datadog/critical/"

  name = "Total inodes usage is very high"
  type = "metric alert"
  message = "Host: {{host.ip}} \nrole: {{host.salt-role}} \n\nThe number of inodes in use as exceeds 90%"
  query = "avg(last_5m):avg:system.fs.inodes.in_use{*} > 90"
}


module "sherpa-intl-dev-local-http" {
  source = "modules/datadog/warning/"

  new_host_delay = "800"
  name = "Sherpa dev internal: {{host.name}} failing local connection check"
  type = "metric alert"
  message = "Sherpa dev internal: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: bedrock-status-server.staging1.hmheng-infra.br.internal' http://127.0.0.1:8080/size`\n"
  query = "avg(last_1m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.dev.internal.,url:http://127.0.0.1:8080/health} by {host} < 1"
}

module "sherpa-extl-dev-local-http" {
  source = "modules/datadog/warning/"

  new_host_delay = "800"
  name = "Sherpa dev external: {{host.name}} failing local connection check"
  type = "metric alert"
  message = "Sherpa dev external: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: api.dev.eng.hmhco.com ' http://127.0.0.1:8080/bedrock-sherpa-monitor/health`"
  query = "avg(last_5m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.dev.external,url:http://127.0.0.1:8080/bedrock-sherpa-monitor/health} by {host} < 1"
}

module "sherpa-intl-int-local-http" {
  source = "modules/datadog/warning/"

  new_host_delay = "800"
  name = "Sherpa int internal: {{host.name}} failing local connection check"
  type = "metric alert"
  message = "Sherpa int internal: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: bedrock-status-server.staging1.hmheng-infra.br.internal' http://127.0.0.1:8080/size`\n"
  query = "avg(last_1m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.int.internal.,url:http://127.0.0.1:8080/health} by {host} < 1"
}

module "sherpa-extl-int-local-http" {
  source = "modules/datadog/warning/"

  new_host_delay = "800"
  name = "Sherpa int external: {{host.name}} failing local connection check"
  type = "metric alert"
  message = "Sherpa int external: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: api.int.eng.hmhco.com ' http://127.0.0.1:8080/bedrock-sherpa-monitor/health`"
  query = "avg(last_5m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.int.external,url:http://127.0.0.1:8080/bedrock-sherpa-monitor/health} by {host} < 1"
}

module "sherpa-intl-cert-local-http" {
  source = "modules/datadog/warning/"

  new_host_delay = "800"
  name = "Sherpa cert internal: {{host.name}} failing local connection check"
  type = "metric alert"
  message = "Sherpa cert internal: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: bedrock-status-server.staging1.hmheng-infra.br.internal' http://127.0.0.1:8080/size`\n"
  query = "avg(last_1m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.cert.internal.,url:http://127.0.0.1:8080/health} by {host} < 1"
}

module "sherpa-extl-cert-local-http" {
  source = "modules/datadog/warning/"

  new_host_delay = "800"
  name = "Sherpa cert external: {{host.name}} failing local connection check"
  type = "metric alert"
  message = "Sherpa cert external: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: api.cert.eng.hmhco.com ' http://127.0.0.1:8080/bedrock-sherpa-monitor/health`"
  query = "avg(last_5m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.cert.external,url:http://127.0.0.1:8080/bedrock-sherpa-monitor/health} by {host} < 1"
}

module "sherpa-intl-cert2-local-http" {
  source = "modules/datadog/warning/"

  new_host_delay = "800"
  name = "Sherpa cert2 internal: {{host.name}} failing local connection check"
  type = "metric alert"
  message = "Sherpa cert2 internal: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: bedrock-status-server.staging1.hmheng-infra.br.internal' http://127.0.0.1:8080/size`\n"
  query = "avg(last_1m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.cert2.internal.,url:http://127.0.0.1:8080/health} by {host} < 1"
}

module "sherpa-extl-cert2-local-http" {
  source = "modules/datadog/warning/"

  new_host_delay = "800"
  name = "Sherpa cert2 external: {{host.name}} failing local connection check"
  type = "metric alert"
  message = "Sherpa cert2 external: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: api.cert2.eng.hmhco.com ' http://127.0.0.1:8080/bedrock-sherpa-monitor/health`"
  query = "avg(last_5m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.cert2.external,url:http://127.0.0.1:8080/bedrock-sherpa-monitor/health} by {host} < 1"
}

module "sherpa-intl-certrv-local-http" {
  source = "modules/datadog/warning/"

  new_host_delay = "800"
  name = "Sherpa certrv internal: {{host.name}} failing local connection check"
  type = "metric alert"
  message = "Sherpa certrv internal: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: bedrock-status-server.staging1.hmheng-infra.br.internal' http://127.0.0.1:8080/size`\n"
  query = "avg(last_1m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.certrv.internal.,url:http://127.0.0.1:8080/health} by {host} < 1"
}

module "sherpa-extl-certrv-local-http" {
  source = "modules/datadog/warning/"

  new_host_delay = "800"
  name = "Sherpa certrv external: {{host.name}} failing local connection check"
  type = "metric alert"
  message = "Sherpa certrv external: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: api.certrv.eng.hmhco.com ' http://127.0.0.1:8080/bedrock-sherpa-monitor/health`"
  query = "avg(last_5m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.certrv.external,url:http://127.0.0.1:8080/bedrock-sherpa-monitor/health} by {host} < 1"
}

module "sherpa-intl-prodrv-local-http" {
  source = "modules/datadog/warning/"

  new_host_delay = "800"
  name = "Sherpa prodrv internal: {{host.name}} failing local connection check"
  type = "metric alert"
  message = "Sherpa prodrv internal: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: bedrock-status-server.staging1.hmheng-infra.br.internal' http://127.0.0.1:8080/size`\n"
  query = "avg(last_1m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.prodrv.internal.,url:http://127.0.0.1:8080/health} by {host} < 1"
}

module "sherpa-extl-prodrv-local-http" {
  source = "modules/datadog/warning/"

  new_host_delay = "800"
  name = "Sherpa prodrv external: {{host.name}} failing local connection check"
  type = "metric alert"
  message = "Sherpa prodrv external: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: api.prodrv.eng.hmhco.com ' http://127.0.0.1:8080/bedrock-sherpa-monitor/health`"
  query = "avg(last_5m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.prodrv.external,url:http://127.0.0.1:8080/bedrock-sherpa-monitor/health} by {host} < 1"
}

module "sherpa-intl-uat-local-http" {
  source = "modules/datadog/warning/"

  new_host_delay = "800"
  name = "Sherpa uat internal: {{host.name}} failing local connection check"
  type = "metric alert"
  message = "Sherpa uat internal: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: bedrock-status-server.staging1.hmheng-infra.br.internal' http://127.0.0.1:8080/size`\n"
  query = "avg(last_1m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.uat.internal.,url:http://127.0.0.1:8080/health} by {host} < 1"
}

module "sherpa-extl-uat-local-http" {
  source = "modules/datadog/warning/"

  new_host_delay = "800"
  name = "Sherpa uat external: {{host.name}} failing local connection check"
  type = "metric alert"
  message = "Sherpa uat external: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: api.uat.eng.hmhco.com ' http://127.0.0.1:8080/bedrock-sherpa-monitor/health`"
  query = "avg(last_5m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.uat.external,url:http://127.0.0.1:8080/bedrock-sherpa-monitor/health} by {host} < 1"
}

module "sherpa-intl-prod-local-http" {
  source = "modules/datadog/warning/"

  name = "Sherpa prod internal: {{host.name}} failing local connection check"
  new_host_delay = "800"
  type = "metric alert"
  message = "Sherpa prod internal: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: bedrock-status-server.prod.hmheng-infra.br.internal' http://127.0.0.1:8080/size`\n"
  query = "avg(last_1m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.prod.internal.,url:http://127.0.0.1:8080/health} by {host} < 1"
}

module "sherpa-extl-prod-local-http" {
  source = "modules/datadog/warning/"

  name = "Sherpa prod external: {{host.name}} failing local connection check"
  type = "metric alert"
  message = "Sherpa prod external: {{host.name}} failing local connection check\n\nthe follow check is failing:\n`curl -v -H'Host: api.eng.hmhco.com ' http://127.0.0.1:8080/bedrock-sherpa-monitor/health`"
  query = "avg(last_5m):avg:network.http.can_connect{autoscaling_group:brcore01.sherpa.prod.external,url:http://127.0.0.1:8080/bedrock-sherpa-monitor/health} by {host} < 1"
}
