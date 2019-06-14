variable "tag_cost" {
    type = "string"
    default = "clm_oac"
}
variable "tag_stage" {
  type = "string"
}
variable "tag_responsible_party" {
    type = "string"
    default = "@oac"
}

variable "dub_acct_id" {
  type = "map"

  default = {
    dev  = "205685244378"
    int  = "205685244378"
    cert = "205685244378"
    prod = "763216113038"
  }
}
