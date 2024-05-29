output "fgt_1_config" {
  description = "Fortigate 1 bootstrap config"
  value       = data.template_file.fgt_1.rendered
}

output "fgt_2_config" {
  description = "Fortigate 2 bootstrap config"
  value       = data.template_file.fgt_2.rendered
}

output "vpn_psk" {
  description = "IPSEC VPN PreShared Key"
  value       = var.hub[0]["vpn_psk"] == "" ? random_string.vpn_psk.result : var.hub[0]["vpn_psk"]
}

output "api_key" {
  description = "Fortigates API keys"
  value       = var.api_key == null ? random_string.api_key.result : var.api_key
}

output "fgsp_auto-config_secret" {
  description = "Fortigate auto-scale protocol secret password"
  value       = random_string.fgsp_auto-config_secret.result
}

/*
output "fgt_1_ni_ips" {
  description = "Fortigate instance cluster member 1 map of IPs"
  value       = local.fgt_1_ips
}

output "fgt_2_ni_ips" {
  description = "Fortigate instance cluster member 2 map of IPs"
  value       = local.fgt_2_ips
}
*/

output "fgt_1_ports_config" {
  description = "Map of Fortigate ports detailed"
  value       = local.fgt_1_ports_config
}

output "fgt_2_ports_config" {
  description = "Map of Fortigate ports detailed"
  value       = local.fgt_2_ports_config
}

output "ilb_ips" {
  description = "Map of internal LB IP"
  value       = local.o_ilb_ips
}

# ------------------------------------
# Debbuging
# ------------------------------------
output "fgt_subnets_names_others" {
  value = local.fgt_subnets_names_others
}

