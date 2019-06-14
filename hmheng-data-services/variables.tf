# vpc
variable "tag_stage" {
  type = "string"
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

variable "br_aws_account_number" {
  type = "string"
  default = "711638685743"
}
