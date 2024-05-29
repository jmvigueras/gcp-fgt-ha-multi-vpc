output "id" {
  description = "Fortigate instance ID member 1"
  value       = google_compute_instance.fgt.instance_id
}

output "self_link" {
  description = "Fortigate instance SelfLink member 1"
  value       = google_compute_instance.fgt.self_link
}

output "public_ips" {
  description = "Fortigate instance member 1 management public IP"
  value       = { for k, v in google_compute_address.fgt_public_ips : k => v.address }
}