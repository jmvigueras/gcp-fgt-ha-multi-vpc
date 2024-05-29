/*
output "fgt" {
  value = {
    fgt-1_mgmt   = "https://${module.fgt.fgt_active_eip_mgmt}:${local.admin_port}"
    fgt-1_pass   = module.fgt.fgt_active_id
    fgt-2_mgmt   = module.fgt.fgt_passive_eip_mgmt
    fgt-2_pass   = module.fgt.fgt_passive_id
    fgt-1_public = module.fgt.fgt_active_eip_public
    api_key      = module.fgt_config.api_key
    vpn_psk      = module.fgt_config.vpn_psk
  }
}
output "vm_spoke" {
  value = {
    admin_user = split("@", data.google_client_openid_userinfo.me.email)[0]
    pip        = module.vm_spoke.vm["pip"]
    ip         = module.vm_spoke.vm["ip"]
  }
}
*/

output "fgt_1_ports_config" {
  value = module.fgt_config.fgt_1_ports_config
}
output "fgt_2_ports_config" {
  value = module.fgt_config.fgt_2_ports_config
}
output "subnet_ids" {
  value = module.fgt_vpc.subnet_ids
}
output "vpc_ids" {
  value = module.fgt_vpc.vpc_ids
}
output "fgt_1_config" {
  value = module.fgt_config.fgt_1_config
}
output "fgt_subnets_names_others" {
  value = module.fgt_config.fgt_subnets_names_others
}
output "ilb_ips" {
  value = module.fgt_config.ilb_ips
}
output "fgt_1" {
  value = module.fgt_1.self_link
}
output "fgt_2" {
  value = module.fgt_2.self_link
}