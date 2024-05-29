variable "prefix" {
  description = "GCP resourcers prefix description"
  type        = string
  default     = "terraform"
}

variable "tags" {
  description = "Map of VPC subnets name"
  type        = list(string)
  default     = []
}

variable "region" {
  description = "GCP region to deploy"
  type        = string
  default     = "europe-west4" #Default Region
}

variable "zone" {
  description = "GCP region Zone 1"
  type        = string
  default     = "europe-west4-a" #Default Zone
}

variable "machine" {
  description = "GCP instance machine type"
  type        = string
  default     = "n1-standard-4"
}

variable "license_type" {
  description = "License type for FortiGate-VM Instances, either byol or payg."
  type        = string
  default     = "payg"
}

/*
variable "license_file" {
  description = "Path to your own byol license file, license1.lic"
  type    = string
  default = "./licenses/license1.lic"
}
*/

variable "fgt_version" {
  description = "FortiOS version"
  type        = string
  default     = "727"
}

variable "fgt_config" {
  description = "Bootstrap config for Fortigate 1"
  type        = string
  default     = ""
}

variable "rsa-public-key" {
  description = "SSH RSA public key"
  type        = string
  default     = null
}

variable "gcp-user_name" {
  description = "GCP user name that launch Terrafrom"
  type        = string
  default     = null
}

variable "fgt_ports_config" {
  description = "Map of string with Fortigate membe 1 IPs"
  type        = map(map(string))
  default     = null
}

variable "subnet_names" {
  description = "Map of VPC subnets name"
  type        = map(string)
  default     = null
}