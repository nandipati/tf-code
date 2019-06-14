variable "stage" {
  type = "string"
}

variable "dns_zone_id" {
  type = "map"

  default = {
    dev    = "Z1EHTM4U1ZZVN5"
    int    = "Z2FKVQGIN9K9I"
    cert   = "Z1W6LLKXJV9SZL"
    cert2  = "Z1UBHBTDF1PMLK"
    certrv = "Z2Z4XJMRZ0UOWH"
    prodrv = "Z23RJSTB6BALM"
    uat    = "Z2PIUJERW9MHNA"
    prod   = "Z2WUOZOGBH83LP"
  }
}

variable "dns_sub_stage" {
  type = "map"

  default = {
    dev  = ".dev"
    uat  = ".uat"
    prod = ""
  }
}

variable "bedrock_role" {
  type    = "string"
  default = "hmheng-techops"
}

variable "custom_ssl_cert_enabled" {
  type = "map"

  default = {
    dev  = 0
    uat  = 1
    prod = 1
  }
}
