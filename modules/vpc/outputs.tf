output "vpc_names" {
  description = "Map of VPC names"
  value       = { for k, v in google_compute_network.vpcs : k => v.name }
}

output "vpc_self_links" {
  description = "Map of VPC Self Links"
  value       = { for k, v in google_compute_network.vpcs : k => v.self_link }
}

output "vpc_ids" {
  description = "Map of VPC IDs"
  value       = { for k, v in google_compute_network.vpcs : k => v.id }
}

output "subnet_names" {
  description = "List of subnets Names"
  value       = { for k, v in google_compute_subnetwork.subnets : k => v.name }
}

output "subnet_self_links" {
  description = "List of subnets IDs"
  value       = { for k, v in google_compute_subnetwork.subnets : k => v.self_link }
}

output "subnet_ids" {
  description = "List of subnets IDs"
  value       = { for k, v in google_compute_subnetwork.subnets : k => v.id }
}

output "fwr_tags" {
  description = "Map of fwr names and tags"
  value       = [for k, v in var.subnet_cidrs : "${var.prefix}-subnet-${k}-t-fwr"]
}