module "dev-ch" {
  source = "modules/ch/v1/"

  stage                              = "dev"
  service_name                       = "ch"
  class_object_read_capacity         = 1
  class_object_write_capacity        = 1
  class_content_read_capacity        = 1
  class_content_write_capacity       = 1
  calculated_behavior_read_capacity  = 1
  calculated_behavior_write_capacity = 1
}

module "int-ch" {
  source = "modules/ch/v1/"

  stage                              = "int"
  service_name                       = "ch"
  class_object_read_capacity         = 1
  class_object_write_capacity        = 1
  class_content_read_capacity        = 1
  class_content_write_capacity       = 1
  calculated_behavior_read_capacity  = 10
  calculated_behavior_write_capacity = 10
}


module "cert-ch" {
  source = "modules/ch/v1/"

  stage                              = "cert"
  service_name                       = "ch"
  class_object_read_capacity         = 5
  class_object_write_capacity        = 5
  class_content_read_capacity        = 5
  class_content_write_capacity       = 5
  calculated_behavior_read_capacity  = 10
  calculated_behavior_write_capacity = 10
}


module "prod-ch" {
  source = "modules/ch/v1/"

  stage                              = "prod"
  service_name                       = "ch"
  class_object_read_capacity         = 10
  class_object_write_capacity        = 5
  class_content_read_capacity        = 10
  class_content_write_capacity       = 5
  calculated_behavior_read_capacity  = 10
  calculated_behavior_write_capacity = 10
}
