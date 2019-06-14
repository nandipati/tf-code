variable "elb_name" {
  type = "string"		
}

variable "monitor_window" {
  type = "string"
}

variable "environment" {
  type = "string"
  description = "The environment to monitor."
}

variable "unhealthy_host_count" {
  type = "string"
  description = "The number of unhealthy hosts that trigger the alert."
}

variable "contacts" {
  type = "list"
  description = "The contacts to send the notification."
  default = []
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
