variable "tag_environment" {
  type    = "string"
  default = "brnpb"
}

variable "tag_stage" {
  type = "string"
}

variable "tag_cost" {
  type    = "string"
  default = "ds_isgservice"
}

variable "tag_cost_center" {
  type    = "string"
  default = "CTGT6160"
}

variable "tag_responsible_party" {
  type    = "string"
  default = "@dataserv-hmhcentral @hmhone-dataservices @hmhone-dataservic-dev"
}

# kinesis streams
variable "shard_count" {
  type = "map"

  default = {
    dev    = "1"
    int    = "1"
    cert   = "1"
    certrv = "1"
    prodrv = "1"
    prod   = "1"
  }
}

variable "retention_period" {
  type    = "string"
  default = 168
}

variable "hmhcentral_aws_acc_ids" {
  type = "map"

  default = {
    dev    = "431353658782"
    int    = "431353658782"
    cert   = "431353658782"
    certrv = "431353658782"
    prodrv = "431353658782"
    prod   = "005871186807"
  }
}
