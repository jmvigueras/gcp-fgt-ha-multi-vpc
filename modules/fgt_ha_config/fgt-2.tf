##############################################################################################################
# FGT PASSIVE VM
##############################################################################################################

# Data template fgt_1
data "template_file" "fgt_2" {
  template = file("${path.module}/templates/fgt-all.conf")

  vars = {
    fgt_id          = local.fgt_2_id
    admin_port      = var.admin_port
    admin_cidr      = var.admin_cidr
    adminusername   = "admin"
    type            = var.license_type
    license_file    = var.license_file_2
    fortiflex_token = var.fortiflex_token_2
    api_key         = var.api_key == null ? random_string.api_key.result : var.api_key

    config_license    = data.template_file.config_license_fgt_2.rendered
    config_interfaces = join("\n", [for i, v in data.template_file.config_interfaces_fgt_2 : v.rendered])
    config_routes     = join("\n", data.template_file.config_routes.*.rendered)
    config_fw_policy  = var.config_fw_policy ? data.template_file.config_fw_policy.rendered : ""
    config_fgcp       = var.config_fgcp ? data.template_file.config_fgcp_fgt_2.rendered : ""
    config_xlb        = join("\n", [for k, v in data.template_file.config_xlb : v.rendered])
    config_fmg        = var.config_fmg ? data.template_file.config_fmg_fgt_2.rendered : ""
    config_faz        = var.config_faz ? data.template_file.config_faz_fgt_2.rendered : ""
    config_extra      = var.fgt_2_extra_config
  }
}

data "template_file" "config_license_fgt_2" {
  template = file("${path.module}/templates/fgt_license.conf")
  vars = {
    license_type = var.license_type
    license_file = var.license_type
    flex_token   = var.fortiflex_token_1
  }
}

data "template_file" "config_interfaces_fgt_2" {
  for_each = local.fgt_2_ports_config
  template = file("${path.module}/templates/fgt_interface.conf")
  vars = {
    port  = each.value["port"]
    ip    = each.value["ip"]
    mask  = each.value["mask"]
    gw    = each.value["gw"]
    alias = each.value["alias"]
  }
}

data "template_file" "config_fgcp_fgt_2" {
  template = file("${path.module}/templates/gcp_fgt_ha_fgcp.conf")
  vars = {
    fgt_priority = 190
    ha_port      = local.fgt_port_role["mgmt"]
    ha_gw        = local.fgt_2_ports_config_basic[local.fgt_port_role["mgmt"]]["gw"]
    ha_mask      = local.fgt_2_ports_config_basic[local.fgt_port_role["mgmt"]]["mask"]
    # peerip       = local.fgt_1_ips["mgmt"]
    peerip = ""
  }
}

data "template_file" "config_faz_fgt_2" {
  template = file("${path.module}/templates/fgt_faz.conf")
  vars = {
    ip                      = var.faz_ip
    sn                      = var.faz_sn
    source_ip               = var.faz_fgt_2_source_ip
    interface_select_method = var.faz_interface_select_method
  }
}

data "template_file" "config_fmg_fgt_2" {
  template = file("${path.module}/templates/fgt_fmg.conf")
  vars = {
    ip                      = var.fmg_ip
    sn                      = var.fmg_sn
    source_ip               = var.fmg_fgt_2_source_ip
    interface_select_method = var.fmg_interface_select_method
  }
}