terraform {
  backend "atlas" {
    address = "https://terraform.eng.hmhco.com"
    name    = "hmhco/hmheng-math-inventory"
  }
}