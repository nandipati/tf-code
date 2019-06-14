module "dev-partner-service-cache" {
  source = "modules/partner-service-cache/v1/"

  zone_id   = "Z1EHTM4U1ZZVN5"
  tag_stage = "dev"
}

module "int-partner-service-cache" {
  source     = "modules/partner-service-cache/v1/"
  cache_type = "cache.t2.medium"
  zone_id    = "Z2FKVQGIN9K9I"
  tag_stage  = "int"
}
