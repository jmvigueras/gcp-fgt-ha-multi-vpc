#------------------------------------------------------------------------------------------------------------
# Create VPCs and subnets Fortigate
#------------------------------------------------------------------------------------------------------------
module "fgt_vpc" {
  source = "./modules/vpc"

  region = local.region
  prefix = local.prefix

  fgt_subnet_names = local.fgt_subnet_names
  subnet_cidrs     = local.subnet_cidrs
}
#------------------------------------------------------------------------------------------------------------
# Create FGT cluster config
#------------------------------------------------------------------------------------------------------------
module "fgt_config" {
  source = "./modules/fgt_ha_config"

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port

  fgt_subnet_names = local.fgt_subnet_names
  subnet_cidrs     = local.subnet_cidrs
  subnet_names     = module.fgt_vpc.subnet_names
  vpc_names        = module.fgt_vpc.vpc_names
  cidr_host        = 10

  config_fgcp = local.cluster_type == "fgcp" ? true : false
  config_fgsp = local.cluster_type == "fgsp" ? true : false

  config_xlb = true
  #elb_ips    = { "port2" = google_compute_address.elb_frontend_ip.address }
}
#------------------------------------------------------------------------------------------------------------
# Create FGTs instances
#------------------------------------------------------------------------------------------------------------
module "fgt_1" {
  source = "./modules/fgt"

  prefix = "${local.prefix}-fgt-1"
  region = local.region
  zone   = local.zone1
  tags   = module.fgt_vpc.fwr_tags

  machine        = local.machine
  license_type   = local.license_type

  fgt_ports_config = module.fgt_config.fgt_1_ports_config
  fgt_config       = module.fgt_config.fgt_1_config

  fgt_version = local.fgt_version
}
module "fgt_2" {
  source = "./modules/fgt"

  prefix = "${local.prefix}-fgt-2"
  region = local.region
  zone   = local.zone2
  tags   = module.fgt_vpc.fwr_tags

  machine        = local.machine
  license_type   = local.license_type

  fgt_ports_config = module.fgt_config.fgt_2_ports_config
  fgt_config       = module.fgt_config.fgt_2_config

  fgt_version = local.fgt_version
}
#------------------------------------------------------------------------------------------------------------
# Create Internal and External Load Balancer
#------------------------------------------------------------------------------------------------------------
# ELB Frontends
resource "google_compute_address" "elb_frontend_ip" {
  name         = "${local.prefix}-elb-frontend-ip"
  region       = local.region
  address_type = "EXTERNAL"
}
# Create eLB and iLB
module "xlb" {
  depends_on = [module.fgt_1, module.fgt_2]
  source     = "./modules/xlb"

  prefix = local.prefix
  region = local.region
  zone1  = local.zone1
  zone2  = local.zone2

  ilb_ips         = module.fgt_config.ilb_ips
  elb_ips         = { "public" = google_compute_address.elb_frontend_ip.address }
  fgt_1_self_link = module.fgt_1.self_link
  fgt_2_self_link = module.fgt_2.self_link
}