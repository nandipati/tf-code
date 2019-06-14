module "dev-reporting-api" {
  source = "modules/reporting-api/v1/"

  stage                          = "dev"
  db_class                       = "db.m3.medium"
  db_username                    = "cntm_int_master"
  db_password                    = "8GXP?ZCbnPaUA?nM?2$YJwz&"
  db_allocated_storage           = "50"
  db_engine_version              = "9.3.20"
  db_parameter_group_name        = "default.postgres9.3"
  db_parameter_max_wal_senders   = "10"
  db_parameter_statement_timeout = "900000"
  db_parameter_max_standby_streaming_delay = "900"
  db_create_from_snapshot        = "arn:aws:rds:us-east-1:187631879586:snapshot:cntm-int-reporting-brcopy"
  db_auto_minor_version_upgrade     = "false"
}

module "int-reporting-api" {
  source = "modules/reporting-api/v1/"

  stage                          = "int"
  db_class                       = "db.m3.medium"
  db_username                    = "cntm_int_master"
  db_password                    = "N-vC+TdseGQcdg7-aW6-b4JM"
  db_allocated_storage           = "50"
  db_engine_version              = "9.3.20"
  db_parameter_group_name        = "default.postgres9.3"
  db_parameter_max_wal_senders   = "10"
  db_parameter_statement_timeout = "900000"
  db_parameter_max_standby_streaming_delay = "900"
  db_create_from_snapshot        = "arn:aws:rds:us-east-1:187631879586:snapshot:cntm-int-reporting-brcopy"
  db_auto_minor_version_upgrade     = "false"
}

module "cert-reporting-api" {
  source = "modules/reporting-api/v1/"

  stage                          = "cert"
  db_class                       = "db.m3.large"
  db_username                    = "cntm_cert_master"
  db_password                    = "uH8X4hm-3BwGAsHH7mb5CppR"
  db_allocated_storage           = "200"
  db_engine_version              = "9.3.20"
  db_parameter_group_name        = "default.postgres9.3"
  db_parameter_max_wal_senders   = "10"
  db_parameter_statement_timeout = "900000"
  db_parameter_max_standby_streaming_delay = "90000"
  db_auto_minor_version_upgrade  = "false"
}

module "prod-reporting-api" {
  source = "modules/reporting-api/v1/"

  stage                          = "prod"
  db_class                       = "db.m3.large"
  db_username                    = "cntm_prod_master"
  db_password                    = "fFpdNUU7j8Nv5FNdSgzyW7vg"
  db_allocated_storage           = "200"
  db_engine_version              = "9.3.20"
  db_parameter_group_name        = "default.postgres9.3"
  db_parameter_max_wal_senders   = "10"
  db_parameter_statement_timeout = "900000"
  db_parameter_max_standby_streaming_delay = "90000"
  db_auto_minor_version_upgrade  = "false"
  db_multi_az                    = "true"
}

