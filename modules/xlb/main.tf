#------------------------------------------------------------------------------------------------------------
# Create unmanaged instance groups
#------------------------------------------------------------------------------------------------------------
# Create FGT 1 instance group
resource "google_compute_instance_group" "lb_group_fgt_1" {
  name      = "${var.prefix}-lb-group-fgt-1"
  zone      = var.zone1
  instances = [var.fgt_1_self_link]
}
# Create FGT 2 instance group
resource "google_compute_instance_group" "lb_group_fgt_2" {
  name      = "${var.prefix}-lb-group-fgt-2"
  zone      = var.zone2
  instances = [var.fgt_2_self_link]
}
#------------------------------------------------------------------------------------------------------------
# Create iLB
#------------------------------------------------------------------------------------------------------------
# Create health checks
resource "google_compute_region_health_check" "ilb_hck_fgt" {
  name               = "${var.prefix}-ilb-fgt-health-check"
  region             = var.region
  check_interval_sec = 2
  timeout_sec        = 2

  tcp_health_check {
    port = var.backend_probe_port
  }
}
# Create Internal Load Balancer
resource "google_compute_region_backend_service" "ilb" {
  for_each = var.ilb_ips

  provider = google-beta
  name     = "${var.prefix}-ilb-${each.value["alias"]}"
  region   = var.region
  network  = each.value["network"]

  load_balancing_scheme = "INTERNAL"
  protocol              = "UNSPECIFIED"

  backend {
    group = google_compute_instance_group.lb_group_fgt_1.id
  }
  backend {
    group = google_compute_instance_group.lb_group_fgt_2.id
  }

  health_checks = [google_compute_region_health_check.ilb_hck_fgt.id]
  connection_tracking_policy {
    connection_persistence_on_unhealthy_backends = "NEVER_PERSIST"
  }
}
# Create forwarding rule to ILB in private VPC
resource "google_compute_forwarding_rule" "ilb_fwd_rule_passthrought" {
  for_each = var.ilb_ips

  name   = "${var.prefix}-ilb-fwd-rule-ilb-${each.value["alias"]}"
  region = var.region

  load_balancing_scheme = "INTERNAL"
  all_ports             = true
  backend_service       = google_compute_region_backend_service.ilb[each.key].id
  network               = each.value["network"]
  subnetwork            = each.value["subnetwork"]
  ip_address            = each.value["ip"]
}
#------------------------------------------------------------------------------------------------------------
# Create RFC1918 routes to iLB in VPC private
#------------------------------------------------------------------------------------------------------------
resource "google_compute_route" "private_route_ilb_1" {
  for_each = var.ilb_ips

  name         = "${var.prefix}-private-route-ilb-${each.value["alias"]}-1"
  dest_range   = "192.168.0.0/16"
  network      = each.value["network"]
  next_hop_ilb = each.value["ip"]
  priority     = 100
}
resource "google_compute_route" "private_route_ilb_2" {
  for_each = var.ilb_ips

  name         = "${var.prefix}-private-route-ilb-${each.value["alias"]}-2"
  dest_range   = "10.0.0.0/8"
  network      = each.value["network"]
  next_hop_ilb = each.value["ip"]
  priority     = 100
}
resource "google_compute_route" "private_route_ilb_3" {
  for_each = var.ilb_ips

  name         = "${var.prefix}-private-route-ilb-${each.value["alias"]}-3"
  dest_range   = "172.16.0.0/12"
  network      = each.value["network"]
  next_hop_ilb = each.value["ip"]
  priority     = 100
}
#------------------------------------------------------------------------------------------------------------
# Create eLB
#------------------------------------------------------------------------------------------------------------
# Create health checks (regional)
resource "google_compute_region_health_check" "elb_hck_fgt" {
  name               = "${var.prefix}-elb-fgt-health-check"
  region             = var.region
  check_interval_sec = 5
  timeout_sec        = 1

  tcp_health_check {
    port = var.backend_probe_port
  }
}
# Create External Load Balancer
resource "google_compute_region_backend_service" "elb" {
  for_each = var.elb_ips

  provider = google-beta
  name     = "${var.prefix}-elb-${each.key}"
  region   = var.region

  load_balancing_scheme = "EXTERNAL"
  protocol              = "UNSPECIFIED"

  backend {
    group = google_compute_instance_group.lb_group_fgt_1.id
  }
  backend {
    group = google_compute_instance_group.lb_group_fgt_2.id
  }

  health_checks = [google_compute_region_health_check.elb_hck_fgt.id]
  connection_tracking_policy {
    connection_persistence_on_unhealthy_backends = "NEVER_PERSIST"
  }
}
# ELB Frontend forwarding rule
resource "google_compute_forwarding_rule" "elb_fwd_l3" {
  for_each = var.elb_ips

  name   = "${var.prefix}-elb-fwd-rule-l3-${each.key}"
  region = var.region

  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "L3_DEFAULT"
  all_ports             = true
  backend_service       = google_compute_region_backend_service.elb[each.key].id
  ip_address            = each.value
}