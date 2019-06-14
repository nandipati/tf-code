# Current project variables
variable "aurora_role" {
  type    = "string"
  default = "hmheng-uds"
}

variable "aws_region" {
  type    = "string"
  default = "us-east-1"
}

variable "stage" {
  type = "string"
}

variable "service_name" {
  type    = "string"
  default = "uds"
}

variable "calculated_behavior_read_capacity_by_stage" {
  type = "map"

  default = {
    dev  = 1
    int  = 30
    cert = 30
    prod = 30
  }
}

variable "calculated_behavior_write_capacity_by_stage" {
  type = "map"

  default = {
    dev  = 1
    int  = 30
    cert = 30
    prod = 30
  }
}

variable "apps_read_capacity_by_stage" {
  type = "map"

  default = {
    dev  = 1
    int  = 10
    cert = 10
    prod = 10
  }
}

variable "apps_write_capacity_by_stage" {
  type = "map"

  default = {
    dev  = 1
    int  = 10
    cert = 10
    prod = 10
  }
}

variable "app_data_json_read_capacity_by_stage" {
  type = "map"

  default = {
    dev  = 1
    int  = 25
    cert = 25
    prod = 25
  }
}

variable "app_data_json_write_capacity_by_stage" {
  type = "map"

  default = {
    dev  = 1
    int  = 25
    cert = 25
    prod = 25
  }
}

variable "app_data_json_gsi_read_capacity_by_stage" {
  type = "map"

  default = {
    dev  = 1
    int  = 25
    cert = 25
    prod = 25
  }
}

variable "app_data_json_gsi_write_capacity_by_stage" {
  type = "map"

  default = {
    dev  = 1
    int  = 25
    cert = 25
    prod = 25
  }
}

variable "authz_read_capacity_by_stage" {
  type = "map"

  default = {
    dev  = 1
    int  = 10
    cert = 10
    prod = 10
  }
}

variable "authz_write_capacity_by_stage" {
  type = "map"

  default = {
    dev  = 1
    int  = 10
    cert = 10
    prod = 10
  }
}

variable "share_read_capacity_by_stage" {
  type = "map"

  default = {
    dev  = 1
    int  = 10
    cert = 10
    prod = 10
  }
}

variable "share_write_capacity_by_stage" {
  type = "map"

  default = {
    dev  = 1
    int  = 10
    cert = 10
    prod = 10
  }
}

variable "share_by_user_gsi_read_capacity_by_stage" {
  type = "map"

  default = {
    dev  = 1
    int  = 10
    cert = 10
    prod = 10
  }
}

variable "share_by_user_gsi_write_capacity_by_stage" {
  type = "map"

  default = {
    dev  = 1
    int  = 10
    cert = 10
    prod = 10
  }
}

variable "cost" {
  type    = "string"
  default = "hmheng-uds"
}

variable "contact" {
  type    = "string"
  default = "slack:uds"
}

variable "br_aws_account_number" {
  type    = "string"
  default = "711638685743"
}
