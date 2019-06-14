variable "process_name" {
  type = "string"		
}

variable "ok_threshold" {
  type = "string"
  description = "The number of consecutive successes after which the alert is resolved."
}

variable "warning_threshold" {
  type = "string"
  description = "The number of consecutive failures after which the alert is triggered."
}

variable "critical_threshold" {
  type = "string"
  description = "The number of consecutive failures after which the alert is triggered."
}

variable "notify_no_data" {
  type = "string"		
  default = "false"		
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

variable "silenced" {
  type = "map"		
  default = {}		
}
