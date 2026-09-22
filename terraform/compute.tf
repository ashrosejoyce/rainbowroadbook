resource "google_compute_instance" "app_vm" {
  name         = "rainbowroadbook-app-vm"
  machine_type = "e2-small"
  zone         = "us-central1-a"
  tags         = ["rainbowroadbook-app"]

  deletion_protection = false

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12-bookworm-v20260908"
      size  = 10
      type  = "pd-balanced"
    }
  }

  network_interface {
    network    = "default"
    subnetwork = "default"

    access_config {
      nat_ip       = google_compute_address.app_ip.address
      network_tier = "PREMIUM"
    }
  }

  service_account {
    email  = "523773459301-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

  metadata = {
    enable-oslogin = "TRUE"
    startup-script = <<-EOT
      #!/usr/bin/env bash
      set -euo pipefail
      cat > /etc/cron.weekly/rainbowroadbook-housekeeping <<'SCRIPT'
      ${file("${path.module}/../scripts/vm-housekeeping.sh")}
      SCRIPT
      chmod +x /etc/cron.weekly/rainbowroadbook-housekeeping
    EOT
  }

  shielded_instance_config {
    enable_secure_boot          = false
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  lifecycle {
    prevent_destroy = true
  }
}