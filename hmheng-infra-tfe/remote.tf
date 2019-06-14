terraform {
  backend "atlas" {
    address = "https://terraform.eng.hmhco.com"
    name    = "hmhco/datadog_monitors"
  }
}
