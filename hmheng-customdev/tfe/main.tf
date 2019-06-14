module "cert-chiro-api" {
  source = "modules/chiro-api/v1/"

  stage                = "cert"
  db_class             = "db.t2.large"
  db_username          = "chiroapi"
  db_password          = "VhmltP4zPVhWuPa8QRwkAhHZd"
  db_allocated_storage = "10"
}

module "prod-chiro-api" {
  source = "modules/chiro-api/v1/"

  stage                = "prod"
  db_class             = "db.r4.large"
  db_username          = "chiroapi"
  db_password          = "sJgW8fuXkgc3uuAccMGehNNvL"
  db_allocated_storage = "50"
}
