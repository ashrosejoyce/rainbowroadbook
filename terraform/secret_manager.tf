resource "google_secret_manager_secret" "django_secret_key" {
  secret_id = "rainbowroadbook-django-secret-key"

  replication {
    auto {}
  }
}
