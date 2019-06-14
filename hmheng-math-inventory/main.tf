module "dev-math-inventory-api" {
  source = "modules/math-inventory-api/v1/"

  stage                          = "dev"
  db_class                       = "db.t2.small"
  db_password                    = "70727e8e427511e8b8836d215c69faab"
  aws_rds_cluster_instance_count = 1
}

module "dev-math-inventory-config-server" {
  source = "modules/math-inventory-config-server/v1/"

  stage = "dev"
}

module "dev-math-inventory-cache" {
  source = "modules/math-inventory-cache/v1/"

  zone_id   = "Z1EHTM4U1ZZVN5"
  tag_stage = "dev"
}

module "int-math-inventory-api" {
  source = "modules/math-inventory-api/v1/"

  stage                          = "int"
  db_class                       = "db.t2.medium"
  db_password                    = "pvwepr9thnxwhv2j3srn75a84482qbkd"
  aws_rds_cluster_instance_count = 1
}

module "int-math-inventory-config-server" {
  source = "modules/math-inventory-config-server/v1/"

  stage = "int"
}

module "int-math-inventory-cache" {
  source     = "modules/math-inventory-cache/v1/"
  cache_type = "cache.t2.medium"
  zone_id    = "Z2FKVQGIN9K9I"
  tag_stage  = "int"
}
