locals {
  # ----------------------------------------------------------------------------------
  # FGT IPs
  # ----------------------------------------------------------------------------------
  # Map of fortigate port and role ("public", "private", "mgmt")
  fgt_port_role = { for k, v in var.fgt_subnet_names : one(slice(split(".", k), 1, 2)) => one(slice(split(".", k), 0, 1)) }

  # FGT subnet list (fgt subnet list and rest of subnets)
  fgt_subnet_names_basic   = [for k, v in var.fgt_subnet_names : one(slice(split(".", k), 1, 2))]
  fgt_subnets_names_others = tolist(setsubtract(keys(var.subnet_cidrs), values(var.fgt_subnet_names)))

  # ----------------------------------------------------------------------------------
  # iLB IPs
  # ----------------------------------------------------------------------------------
  # Create list of IPs for eLB an iLB
  ilb_ips = { for k, v in local.fgt_1_ports_config : k => cidrhost(v["cidr"], var.cidr_host - 1) if strcontains(v["tag"], "private") }
  elb_ips = var.elb_ips
  lb_ips  = merge(local.ilb_ips, local.elb_ips)

  # Output map of private IPs for iLB
  o_ilb_ips = { for k, v in local.fgt_1_ports_config :
    k => {
      network    = v["network"]
      subnetwork = v["subnetwork"]
      alias      = v["alias"]
      ip         = cidrhost(v["cidr"], var.cidr_host - 1)
  } if strcontains(v["tag"], "private") }

  # ----------------------------------------------------------------------------------
  # FGT ids
  # ----------------------------------------------------------------------------------
  # fgt_id
  fgt_1_id = var.config_spoke ? "${var.spoke["id"]}-${replace(var.fgt_1_id, ".", "")}" : var.config_hub ? "${var.hub[0]["id"]}-${replace(var.fgt_1_id, ".", "")}" : replace(var.fgt_1_id, ".", "")
  fgt_2_id = var.config_spoke ? "${var.spoke["id"]}-${replace(var.fgt_2_id, ".", "")}" : var.config_hub ? "${var.hub[0]["id"]}-${replace(var.fgt_2_id, ".", "")}" : replace(var.fgt_2_id, ".", "")

  # ----------------------------------------------------------------------------------
  # FGT ports config
  # ----------------------------------------------------------------------------------
  # List of maps with Fortigate 1 subnets defined at "var.fgt_subnet_names"
  fgt_1_ports_config_basic = { for k, v in var.fgt_subnet_names :
    "port${index(keys(var.fgt_subnet_names), k) + 1}" => {
      port       = "port${index(keys(var.fgt_subnet_names), k) + 1}"
      ip         = cidrhost(lookup(var.subnet_cidrs, v, ""), var.cidr_host)
      mask       = cidrnetmask(lookup(var.subnet_cidrs, v, "255.255.255.255"))
      gw         = cidrhost(lookup(var.subnet_cidrs, v, ""), 1)
      tag        = one(slice(split(".", k), 1, 2))
      public_ip  = alltrue([var.config_public_ip, anytrue([alltrue([strcontains(k, "public"), !var.config_xlb]), strcontains(v, "mgmt")])])
      subnetwork = lookup(var.subnet_names, v, "")
      network    = lookup(var.vpc_names, v, "")
      cidr       = lookup(var.subnet_cidrs, v, "")
      alias      = v
    }
  }
  # List of maps with Fortigate 1 rest of subnet defined at "local.fgt_1_ips"
  fgt_1_ports_config_others = { for i, v in local.fgt_subnets_names_others :
    "port${i + 1 + length(local.fgt_1_ports_config_basic)}" => {
      port       = "port${i + 1 + length(local.fgt_1_ports_config_basic)}"
      ip         = cidrhost(lookup(var.subnet_cidrs, v, ""), var.cidr_host)
      mask       = cidrnetmask(lookup(var.subnet_cidrs, v, "255.255.255.255"))
      gw         = cidrhost(lookup(var.subnet_cidrs, v, ""), 1)
      tag        = ""
      public_ip  = alltrue([var.config_public_ip, anytrue([alltrue([strcontains(v, "public"), !var.config_xlb]), strcontains(v, "mgmt")])])
      subnetwork = lookup(var.subnet_names, v, "")
      network    = lookup(var.vpc_names, v, "")
      cidr       = lookup(var.subnet_cidrs, v, "")
      alias      = v
    }
  }
  fgt_1_ports_config = merge(local.fgt_1_ports_config_basic, local.fgt_1_ports_config_others)

  # List of maps with Fortigate 1 subnets defined at "var.fgt_subnet_names"
  fgt_2_ports_config_basic = { for k, v in var.fgt_subnet_names :
    "port${index(keys(var.fgt_subnet_names), k) + 1}" => {
      port       = "port${index(keys(var.fgt_subnet_names), k) + 1}"
      ip         = cidrhost(lookup(var.subnet_cidrs, v, ""), var.cidr_host + 1)
      mask       = cidrnetmask(lookup(var.subnet_cidrs, v, "255.255.255.255"))
      gw         = cidrhost(lookup(var.subnet_cidrs, v, ""), 1)
      tag        = one(slice(split(".", k), 1, 2))
      public_ip  = alltrue([var.config_public_ip, anytrue([alltrue([strcontains(k, "public"), !var.config_xlb, var.config_fgsp]), strcontains(v, "mgmt")])])
      subnetwork = lookup(var.subnet_names, v, "")
      network    = lookup(var.vpc_names, v, "")
      cidr       = lookup(var.subnet_cidrs, v, "")
      alias      = v
    }
  }
  # List of maps with Fortigate 2 rest of subnet defined at "local.fgt_2_ips"
  fgt_2_ports_config_others = { for i, v in local.fgt_subnets_names_others :
    "port${i + 1 + length(local.fgt_2_ports_config_basic)}" => {
      port       = "port${i + 1 + length(local.fgt_2_ports_config_basic)}"
      ip         = cidrhost(lookup(var.subnet_cidrs, v, ""), var.cidr_host + 1)
      mask       = cidrnetmask(lookup(var.subnet_cidrs, v, "255.255.255.255"))
      gw         = cidrhost(lookup(var.subnet_cidrs, v, ""), 1)
      tag        = ""
      public_ip  = alltrue([var.config_public_ip, anytrue([alltrue([strcontains(v, "public"), !var.config_xlb, var.config_fgsp]), strcontains(v, "mgmt")])])
      subnetwork = lookup(var.subnet_names, v, "")
      network    = lookup(var.vpc_names, v, "")
      cidr       = lookup(var.subnet_cidrs, v, "")
      alias      = v
    }
  }
  fgt_2_ports_config = merge(local.fgt_2_ports_config_basic, local.fgt_2_ports_config_others)

  # List of maps of subnets
  fgt_routes = [for k, v in local.fgt_1_ports_config :
    {
      dst      = strcontains(v["tag"], "public") ? "0.0.0.0" : strcontains(v["tag"], "private") ? "35.191.0.0/16" : ""
      port     = v["port"]
      gw       = v["gw"]
      priority = strcontains(v["tag"], "public") ? "1" : "10"
    } if strcontains(v["tag"], "public") || strcontains(v["tag"], "private")
  ]

}
