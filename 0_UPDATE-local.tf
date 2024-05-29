locals {
  #-----------------------------------------------------------------------------------------------------
  # General variables
  #-----------------------------------------------------------------------------------------------------
  region = "europe-west2"
  zone1  = "europe-west2-a"
  zone2  = "europe-west2-b"
  prefix = "multi-vpc"
  #-----------------------------------------------------------------------------------------------------
  # FGT
  #-----------------------------------------------------------------------------------------------------
  license_type = "payg"
  machine      = "n1-standard-8"

  admin_port = "8443"
  admin_cidr = "0.0.0.0/0"

  cluster_type = "fgcp"
  fgt_version  = "728"

  #-----------------------------------------------------------------------------------------------------
  # FGT VPCs
  #-----------------------------------------------------------------------------------------------------
  # Map of tag asigned to each VPC network associated to fortigate ports and roles ("public", "mgmt" and "private")
  # - Keys must be a combination of unique "port . role"
  fgt_subnet_names = {
    "port1.mgmt"     = "mgmt"
    "port2.public"   = "public"
    "port3.private"  = "hub1"
    "port4.private1" = "hub2"
    "port5.private2" = "hub3"
    "port6.private3" = "hub4"
    "port7.private4" = "hub5"
    "port8.private5" = "hub6"
  }
  # Map of VPC and subnet to deploy
  # - Keys must be the same as defined in local.fgt_subnet_names
  subnet_cidrs = {
    "mgmt"   = "172.30.0.0/26"
    "public" = "172.30.0.128/26"
    "hub1"   = "172.30.1.0/26"
    "hub2"   = "172.30.2.0/26"
    "hub3"   = "172.30.3.0/26"
    "hub4"   = "172.30.4.0/26"
    "hub5"   = "172.30.5.0/26"
    "hub6"   = "172.30.6.0/26"
  }
}