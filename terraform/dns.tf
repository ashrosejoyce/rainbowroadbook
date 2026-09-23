# --- rainbowroadbook.org (primary site + Google Workspace email) ---

resource "google_dns_managed_zone" "org" {
  name        = "rainbowroadbook-org"
  dns_name    = "rainbowroadbook.org."
  description = "Primary domain: website and Google Workspace email"

  depends_on = [google_project_service.dns]

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_dns_record_set" "org_a" {
  managed_zone = google_dns_managed_zone.org.name
  name         = google_dns_managed_zone.org.dns_name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_address.app_ip.address]
}

resource "google_dns_record_set" "org_www_a" {
  managed_zone = google_dns_managed_zone.org.name
  name         = "www.${google_dns_managed_zone.org.dns_name}"
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_address.app_ip.address]
}

resource "google_dns_record_set" "org_mx" {
  managed_zone = google_dns_managed_zone.org.name
  name         = google_dns_managed_zone.org.dns_name
  type         = "MX"
  ttl          = 3600
  rrdatas      = ["1 smtp.google.com."]
}

resource "google_dns_record_set" "org_txt" {
  managed_zone = google_dns_managed_zone.org.name
  name         = google_dns_managed_zone.org.dns_name
  type         = "TXT"
  ttl          = 3600
  rrdatas = [
    "\"google-site-verification=iS88UmgghKvAZ9ZuAApoBfOW_iD5cD0m-IMBBqXTB4w\"",
    "\"v=spf1 include:_spf.google.com ~all\"",
  ]
}

# 2048-bit key exceeds the 255-char TXT string limit, so it's split into two quoted strings
resource "google_dns_record_set" "org_dkim" {
  managed_zone = google_dns_managed_zone.org.name
  name         = "google._domainkey.${google_dns_managed_zone.org.dns_name}"
  type         = "TXT"
  ttl          = 3600
  rrdatas = [
    "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkbsqptHh7fLpG8aNFKihNz/XQzOyN6iKwDhrn0KuJx5AxvS3tQtu7NQi4KoTHAqxY4cwRmsEvVrFZR4id4wmUpvHC3XHgK3gsq4Y4pTPM9YybwN/Q0CFlIf+wtKOEA99ncHBf8ohEf0ZHaDu6flfv2npdzuaJJNqo+yfeAgz3A9xHuZbuOzX836MyTosPz6Zb\" \"FKLl/Hyu/0eQepzLtk4ySi1u4jfUE/sSrH/c/szghhKeHuf7+gNXD+FRq3kW2FmD11lJVDhgoCJniClTx/D4x7CTgMMPBdzdDs8eMvKQSdfT3E2ftz3FLEutHGq2hh2kHUmDyyz9kiEA+H1WeCF+wIDAQAB\"",
  ]
}

resource "google_dns_record_set" "org_dmarc" {
  managed_zone = google_dns_managed_zone.org.name
  name         = "_dmarc.${google_dns_managed_zone.org.dns_name}"
  type         = "TXT"
  ttl          = 3600
  rrdatas      = ["\"v=DMARC1; p=none; rua=mailto:ash@rainbowroadbook.org; pct=100; adkim=s; aspf=s\""]
}

# --- rainbowroadbook.com (redirects to .org; the 301 itself comes from the proxy in Phase G) ---

resource "google_dns_managed_zone" "com" {
  name        = "rainbowroadbook-com"
  dns_name    = "rainbowroadbook.com."
  description = "Secondary domain: redirects to rainbowroadbook.org"

  depends_on = [google_project_service.dns]

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_dns_record_set" "com_a" {
  managed_zone = google_dns_managed_zone.com.name
  name         = google_dns_managed_zone.com.dns_name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_address.app_ip.address]
}

resource "google_dns_record_set" "com_www_a" {
  managed_zone = google_dns_managed_zone.com.name
  name         = "www.${google_dns_managed_zone.com.dns_name}"
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_address.app_ip.address]
}

# --- Nameservers to enter at Whois.com ---

output "org_name_servers" {
  value = google_dns_managed_zone.org.name_servers
}

output "com_name_servers" {
  value = google_dns_managed_zone.com.name_servers
}
