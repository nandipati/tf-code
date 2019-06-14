module "dev-sonarqube-server" {
  source = "modules/sonarqube-server/v1/"

  stage                          = "dev"
  db_class                       = "db.t2.medium"
  db_username                    = "sonarqubedev"
  db_password                    = "j$%Tgr?r6_'S;[Ks"
  db_allocated_storage           = "5"
  db_parameter_group_name        = "default.mysql5.6"
  max_allowed_packet             = "50000000"
  slow_query_log                 = "1"
}

module "prod-sonarqube-server" {
  source = "modules/sonarqube-server/v1/"

  stage                          = "prod"
  db_class                       = "db.t2.medium"
  db_username                    = "sonarqubeprod"
  db_password                    = "TX3)#UcaGPV3!qGQ"
  db_allocated_storage           = "50"
  db_parameter_group_name        = "default.mysql5.6"
  max_allowed_packet             = "50000000"
  slow_query_log                 = "1"
}

module "dev-pactbroker-db" {
  source = "modules/pactbroker-postgres/v1/"

  stage                          = "dev"
  db_class                       = "db.t2.micro"
  db_username                    = "pactbrokeruser"
  db_password                    = "p$%Tgi_r8?'S;[o9"
  db_allocated_storage           = "5"
  db_parameter_group_name        = "default.postgres10"
}
