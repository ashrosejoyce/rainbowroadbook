resource "google_artifact_registry_repository" "images" {
  repository_id = "rainbowroadbook-images"
  location      = "us-central1"
  format        = "DOCKER"
  description   = "Docker Images for API and frontend containers"

  cleanup_policies {
    id     = "Delete Aging"
    action = "DELETE"
    condition {
      tag_state  = "ANY"
      older_than = "2592000s"
    }
  }

  cleanup_policies {
    id     = "Keep Recent"
    action = "KEEP"
    most_recent_versions {
      keep_count = 10
    }
  }
}
