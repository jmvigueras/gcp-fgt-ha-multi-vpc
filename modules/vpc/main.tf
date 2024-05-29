#------------------------------------------------------------------------------------------------------------
# Create VPCs
#------------------------------------------------------------------------------------------------------------
resource "google_compute_network" "vpcs" {
  for_each = var.subnet_cidrs

  name                    = "${var.prefix}-vpc-${each.key}"
  auto_create_subnetworks = false
}
#------------------------------------------------------------------------------------------------------------
# Create subnets
#------------------------------------------------------------------------------------------------------------
resource "google_compute_subnetwork" "subnets" {
  for_each = var.subnet_cidrs

  name          = "${var.prefix}-subnet-${each.key}"
  region        = var.region
  network       = google_compute_network.vpcs[each.key].name
  ip_cidr_range = each.value
}
#------------------------------------------------------------------------------------------------------------
# Create firewalls rules (allow_all)
#------------------------------------------------------------------------------------------------------------
# Firewall Rule External MGMT
resource "google_compute_firewall" "default_allow_fgt" {
  for_each = var.subnet_cidrs

  name    = "${var.prefix}-allow-${each.key}-fgt"
  network = google_compute_network.vpcs[each.key].name

  allow {
    protocol = "all"
  }

  source_ranges = [var.admin_cidr]
  target_tags   = ["${var.prefix}-subnet-${each.key}-t-fwr"]
}
