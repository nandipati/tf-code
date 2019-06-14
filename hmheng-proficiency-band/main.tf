module "dev-proficiency-band-api" {
  source = "modules/proficiency-band-api/v1/"

  stage                          = "dev"
  db_class                       = "db.t2.small"
  db_password                    = "e6qnpLJ3JpBmPKDmgbBqcmuPe7CdgF5V"
  aws_rds_cluster_instance_count = 1
}

module "dev-proficiency-band-config-server" {
  source = "modules/proficiency-band-config-server/v1/"

  stage = "dev"
}

module "dev-proficiency-band-cache" {
  source = "modules/proficiency-band-cache/v1/"

  zone_id   = "Z1EHTM4U1ZZVN5"
  tag_stage = "dev"
}
