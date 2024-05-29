variable "prefix" {
  description = "GCP resourcers prefix description"
  type        = string
  default     = "terraform"
}

variable "region" {
  description = "GCP region to deploy"
  type        = string
  default     = "europe-west4" #Default Region
}

variable "zone1" {
  description = "GCP region Zone 1"
  type        = string
  default     = "europe-west4-a" #Default Zone
}

variable "zone2" {
  description = "GCP region Zone 1"
  type        = string
  default     = "europe-west4-a" #Default Zone
}

variable "fgt_1_self_link" {
  description = "Fortigate instance SelfLink member 1"
  type        = string
  default     = null
}

variable "fgt_2_self_link" {
  description = "Fortigate instance SelfLink member 2"
  type        = string
  default     = null
}

variable "backend_probe_port" {
  description = "Fortigate tcp port for health-checks probes from LB"
  type        = string
  default     = "8008"
}

variable "ilb_ips" {
  description = "Internal Load Balancer IP"
  type        = map(map(string))
  default     = null
}

variable "elb_ips" {
  description = "External Load Balancer IP"
  type        = map(string)
  default     = null
}
