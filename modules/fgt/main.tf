#------------------------------------------------------------------------------------------------------------
# FGT 1 VM
#------------------------------------------------------------------------------------------------------------
# Create new random str
resource "random_string" "randon_str" {
  length  = 5
  special = false
  numeric = true
  upper   = false
}
# Create log disk for active
resource "google_compute_disk" "fgt_logdisk" {
  name = "${var.prefix}-fgt-log-disk-${random_string.randon_str.result}"
  size = 30
  type = "pd-standard"
  zone = var.zone
}

# Create publics IPs
resource "google_compute_address" "fgt_public_ips" {
  for_each = { for k, v in var.fgt_ports_config : k => v if v["public_ip"] }

  name         = "${var.prefix}-fgt-${each.key}-public-ip"
  address_type = "EXTERNAL"
  region       = var.region
}

# Create FGTVM compute active instance
resource "google_compute_instance" "fgt" {
  name           = var.prefix
  machine_type   = var.machine
  zone           = var.zone
  can_ip_forward = "true"

  tags = var.tags

  boot_disk {
    initialize_params {
      image = var.license_type == "byol" ? data.google_compute_image.fgt_image_byol.self_link : data.google_compute_image.fgt_image_payg.self_link
    }
  }
  attached_disk {
    source = google_compute_disk.fgt_logdisk.name
  }

  dynamic "network_interface" {
    for_each = { for k, v in var.fgt_ports_config : k => v if v["public_ip"] }

    content {
      subnetwork = network_interface.value["subnetwork"]
      network_ip = network_interface.value["ip"]
      access_config {
        nat_ip = try(google_compute_address.fgt_public_ips[network_interface.key].address, null)
      }
    }
  }

  dynamic "network_interface" {
    for_each = { for k, v in var.fgt_ports_config : k => v if !v["public_ip"] }

    content {
      subnetwork = network_interface.value["subnetwork"]
      network_ip = network_interface.value["ip"]
    }
  }

  metadata = {
    #ssh-keys  = trimspace("${var.gcp-user_name}:${var.rsa-public-key}")
    user-data = var.fgt_config
  }
  service_account {
    scopes = ["userinfo-email", "compute-rw", "storage-ro", "cloud-platform"]
  }
  scheduling {
    preemptible       = false
    automatic_restart = true
  }
}



#------------------------------------------------------------------------------------------------------------
# Images
#------------------------------------------------------------------------------------------------------------
data "google_compute_image" "fgt_image_payg" {
  project = "fortigcp-project-001"
  filter  = "name=fortinet-fgtondemand-${var.fgt_version}*"
  //filter = "name=fortinet-fgtondemand-724-20230310*"
}

data "google_compute_image" "fgt_image_byol" {
  project = "fortigcp-project-001"
  filter  = "name=fortinet-fgt-${var.fgt_version}*"
  //filter = "name=fortinet-fgt-724-20230310*"
}