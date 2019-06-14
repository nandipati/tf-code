module "dev-reading-inventory-api" {
  source = "modules/reading-inventory-api/v1/"

  stage                          = "dev"
  db_class                       = "db.t2.small"
  db_password                    = "t2djyyprdccpr7khjmpvawmcv97sgcsr"
  aws_rds_cluster_instance_count = 1
}

module "dev-reading-inventory-config-server" {
  source = "modules/reading-inventory-config-server/v1/"

  stage = "dev"
}

module "dev-reading-inventory-cache" {
  source = "modules/reading-inventory-cache/v1/"

  zone_id   = "Z1EHTM4U1ZZVN5"
  tag_stage = "dev"
}

module "int-reading-inventory-api" {
  source = "modules/reading-inventory-api/v1/"

  stage                          = "int"
  db_class                       = "db.t2.medium"
  db_password                    = "dvj4b694bp2usek2rfygw9prmk8n3p5g"
  aws_rds_cluster_instance_count = 1
}

module "int-reading-inventory-config-server" {
  source = "modules/reading-inventory-config-server/v1/"

  stage = "int"
}

module "int-reading-inventory-cache" {
  source     = "modules/reading-inventory-cache/v1/"
  cache_type = "cache.t2.medium"
  zone_id    = "Z1EHTM4U1ZZVN5"
  tag_stage  = "int"
}
