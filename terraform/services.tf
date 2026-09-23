resource "google_project_service" "dns" {
  service            = "dns.googleapis.com"
  disable_on_destroy = false
}
