resource "google_compute_address" "app_ip" {
  name         = "rainbowroadbook-app-ip"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name      = "rainbowroadbook-allow-iap-ssh"
  network   = "default"
  direction = "INGRESS"
  priority  = 1000

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["rainbowroadbook-app"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
