variable "prefix" {
  description = "GCP resourcers prefix description"
  type        = string
  default     = "terraform"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west4"
}

variable "admin_cidr" {
  description = "Fortigates Admin CIDR to create Firewall rules"
  type        = string
  default     = "0.0.0.0/0"
}

variable "fgt_subnet_names" {
  description = "List of names of mandatory subnets (public, mgmt and private) for Fortigates"
  type        = map(string)
  default = {
    "port1.public"  = "public"
    "port2.private" = "private"
    "port3.mgmt"    = "mgmt"
  }
}

variable "subnet_cidrs" {
  description = "VPC Subnets names and CIDRS"
  type        = map(string)
  default = {
    "public"  = "172.30.0.0/26"
    "mgmt"    = "172.30.0.64/26"
    "private" = "172.30.0.128/26"
  }
}

variable "cidr_host" {
  description = "Subnet CIDR host to assign to fortigates"
  type        = number
  default     = 5
}

variable "config_default_fwr" {
  description = "Boolean to configure default allow all Firewall Rules"
  type        = bool
  default     = true
}