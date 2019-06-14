variable "name" {
  type = "string"		
}		
		
variable "type" {		
  type = "string"		
}		
		
variable "message" {		
  type = "string"		
}		
		
variable "query" {		
  type = "string"		
}		
		
variable "thresholds" {		
  type = "map"		
  default = {}		
}		
		
variable "notify_no_data" {		
  type = "string"		
  default = "false"		
}		
		
variable "new_host_delay" {		
  type = "string"		
  default = "300"		
}		
		
variable "evaluation_delay" {		
  type = "string"		
  default = "0"		
}		
		
variable "no_data_timeframe" {		
  type = "string"		
  default = "0"		
}		
		
variable "renotify_interval" {		
  type = "string"		
  default = "0"		
}		
		
variable "notify_audit" {		
  type = "string"		
  default = "false"		
}		
		
variable "timeout_h" {		
  type = "string"		
  default = "0"		
}		
		
variable "include_tags" {		
  type = "string"		
  default = "true"		
}		
		
variable "require_full_window" {		
  type = "string"		
  default = "true"		
}

variable "locked" {		
  type = "string"		
  default = ""		
}		
		
variable "tags" {		
  type = "list"		
  default = []		
}		
		
variable "silenced" {		
  type = "map"		
  default = {}		
}
