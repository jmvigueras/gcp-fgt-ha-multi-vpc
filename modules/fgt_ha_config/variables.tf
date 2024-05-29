#-----------------------------------------------------------------------------------
# Predefined variables for HA
# - config_fgcp   = true (default)
# - confgi_fgsp   = false (default)
#-----------------------------------------------------------------------------------
variable "config_fgcp" {
  type    = bool
  default = false
}
variable "config_fgsp" {
  type    = bool
  default = false
}

#-----------------------------------------------------------------------------------
# Route to change by SDN connector when FGCP and no LB
#-----------------------------------------------------------------------------------
variable "route_tables" {
  type    = list(string)
  default = null
}
variable "cluster_pips" {
  type    = list(string)
  default = null
}

#-----------------------------------------------------------------------------------
# Predefined variables for spoke config
# - config_spoke   = true (default) 
#-----------------------------------------------------------------------------------
variable "config_spoke" {
  type    = bool
  default = false
}

// Default parameters to configure a site
variable "spoke" {
  type = map(any)
  default = {
    id      = "fgt"
    cidr    = "172.30.0.0/23"
    bgp_asn = "65000"
  }
}

// Details to crate VPN connections
variable "hubs" {
  type = list(map(string))
  default = [
    {
      id                = "HUB"
      bgp_asn           = "65000"
      external_ip       = "11.11.11.11"
      hub_ip            = "172.20.30.1"
      site_ip           = "172.20.30.10" // set to "" if VPN mode_cfg is enable
      hck_ip            = "172.20.30.1"
      vpn_psk           = "secret"
      cidr              = "172.20.30.0/24"
      ike_version       = "2"
      network_id        = "1"
      dpd_retryinterval = "5"
      sdwan_port        = "public"
    }
  ]
}

#-----------------------------------------------------------------------------------
# Predefined variables for HUB
# - config_hub   = false (default) 
# - config_vxlan = false (default)
#-----------------------------------------------------------------------------------
variable "config_hub" {
  type    = bool
  default = false
}

// Variable to create a a VPN HUB
variable "hub" {
  type = list(map(string))
  default = [
    {
      id                = "fgt"
      bgp-asn_hub       = "65002"
      bgp-asn_spoke     = "65000"
      vpn_cidr          = "10.10.10.0/24"
      vpn_psk           = "secret-key-123"
      cidr              = "172.30.0.0/23"
      ike-version       = "2"
      network_id        = "1"
      dpd-retryinterval = "10"
      mode_cfg          = true
      vpn_port          = "public"
    }
  ]
}

#-----------------------------------------------------------------------------------
# Predefined variables for creating VXLAN tunnels
# - config_vxlan = false (default) 
#-----------------------------------------------------------------------------------
variable "config_vxlan" {
  type    = bool
  default = false
}

// Details for vxlan connection to hub (simulated L2/MPLS)
variable "hub-peer_vxlan" {
  type = map(string)
  default = {
    bgp-asn   = "65000"
    public-ip = "" // leave in blank if you don't know public IP jet
    remote-ip = "10.10.30.1"
    local-ip  = "10.10.30.2"
    vni       = "1100"
  }
}

#-----------------------------------------------------------------------------------
# Predefined variables for FMG 
# - config_fmg = false (default) 
#-----------------------------------------------------------------------------------
variable "config_fmg" {
  description = "Boolean varible to configure FortiManger"
  type        = bool
  default     = false
}

variable "fmg_ip" {
  description = "FortiManager IP"
  type        = string
  default     = ""
}

variable "fmg_sn" {
  description = "FortiManager SN"
  type        = string
  default     = ""
}

variable "fmg_interface_select_method" {
  description = "Fortigate interface select method to connect to FortiManager"
  type        = string
  default     = ""
}

variable "fmg_fgt_1_source_ip" {
  description = "Fortigate source IP used to connect with Fortimanager"
  type        = string
  default     = ""
}

variable "fmg_fgt_2_source_ip" {
  description = "Fortigate source IP used to connect with Fortimanager"
  type        = string
  default     = ""
}

#-----------------------------------------------------------------------------------
# Predefined variables for FAZ 
# - config_faz = false (default) 
#-----------------------------------------------------------------------------------
variable "config_faz" {
  description = "Boolean varible to configure FortiManger"
  type        = bool
  default     = false
}

variable "faz_ip" {
  description = "FortiAnaluzer IP"
  type        = string
  default     = ""
}

variable "faz_sn" {
  description = "FortiAnalyzer SN"
  type        = string
  default     = ""
}

variable "faz_interface_select_method" {
  description = "Fortigate interface select method to connect to FortiManager"
  type        = string
  default     = ""
}

variable "faz_fgt_1_source_ip" {
  description = "Fortigate source IP used to connect with FortiAnalyzer"
  type        = string
  default     = ""
}

variable "faz_fgt_2_source_ip" {
  description = "Fortigate source IP used to connect with FortiAnalyzer"
  type        = string
  default     = ""
}

#-----------------------------------------------------------------------------------
# Predefined variables for Network Connectivity Center (NCC)
# - config_ncc = false (default) 
#-----------------------------------------------------------------------------------
variable "config_ncc" {
  type    = bool
  default = false
}

variable "ncc_bgp-asn" {
  type    = string
  default = "65515"
}

variable "ncc_peers" {
  type = list(list(string))
  default = [
    ["172.30.0.68", "172.30.0.69"]
  ]
}

#-----------------------------------------------------------------------------------
# Predefined variables for xLB 
# - config_xlb = false (default) 
#-----------------------------------------------------------------------------------
variable "config_xlb" {
  type    = bool
  default = false
}

variable "elb_ips" {
  type    = map(string)
  default = {}
}


#-----------------------------------------------------------------------------------
variable "config_fw_policy" {
  description = "Boolean variable to configure basic allow all policies"
  type        = bool
  default     = true
}

variable "config_public_ip" {
  description = "Boolean variable to determinate if configure public IPs on port"
  type        = bool
  default     = true
}

variable "admin_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "admin_port" {
  type    = string
  default = "8443"
}

variable "api_key" {
  type    = string
  default = null
}

variable "fgt_1_extra_config" {
  type    = string
  default = ""
}

variable "fgt_2_extra_config" {
  type    = string
  default = ""
}

variable "fgt_1_id" {
  description = "Fortigate 1 name"
  type        = string
  default     = "FGT1"
}

variable "fgt_2_id" {
  description = "Fortigate 2 name"
  type        = string
  default     = "FGT2"
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
  description = "Map of subnet CIDRS where Fortigate have and interface"
  type        = map(string)
  default     = null
}

variable "subnet_names" {
  description = "Map of subnet names where Fortigate have and interface"
  type        = map(string)
  default     = null
}

variable "vpc_names" {
  description = "Map of Fortigate VPC names where Fortigate have and interface"
  type        = map(string)
  default     = null
}

variable "cidr_host" {
  type    = number
  default = 10
}

variable "ports" {
  type = map(string)
  default = {
    public  = "port1"
    private = "port2"
    mgtm    = "port3"
    ha_port = "port3"
  }
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  type    = string
  default = "payg"
}

// license file for the active fgt
variable "license_file_1" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "./licenses/license1.lic"
}
// license file for the passive fgt
variable "license_file_2" {
  // Change to your own byol license file, license2.lic
  type    = string
  default = "./licenses/license2.lic"
}

// FortiFlex tokens
variable "fortiflex_token_1" {
  type    = string
  default = ""
}
variable "fortiflex_token_2" {
  type    = string
  default = ""
}

variable "backend-probe_port" {
  type    = string
  default = "8008"
}