resource "google_service_account" "ci" {
  account_id   = "rainbowroadbook-ci"
  display_name = "Rainbow Roadbook CI Pipeline"
  description  = "The service account for CI. CI's service account. The service account made especially for CI."

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_artifact_registry_repository_iam_member" "ci_writer" {
  repository = google_artifact_registry_repository.images.name
  location   = google_artifact_registry_repository.images.location
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.ci.email}"
}

resource "google_artifact_registry_repository_iam_member" "vm_reader" {
  repository = google_artifact_registry_repository.images.name
  location   = google_artifact_registry_repository.images.location
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:523773459301-compute@developer.gserviceaccount.com"
}

resource "google_secret_manager_secret_iam_member" "vm_secret_accessor" {
  secret_id = google_secret_manager_secret.django_secret_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:523773459301-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_custom_role" "ci_ssh_discovery" {
  role_id     = "rainbowroadbook_ci_ssh_discovery"
  title       = "Rainbowroadbook CI SSH discovery"
  description = "Read-only lookups gcloud compute ssh needs before connecting"
  permissions = ["compute.instances.get", "compute.projects.get"]
  stage       = "GA"
}

resource "google_project_iam_member" "ci_ssh_discovery" {
  project = "agile-vortex-508316-k6"
  role    = google_project_iam_custom_role.ci_ssh_discovery.name
  member  = "serviceAccount:${google_service_account.ci.email}"
}

resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "rainbowroadbook-github"
  display_name              = "Github Identity Pool"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "rainbowroadbook-github-actions"

  attribute_condition = "assertion.repository=='ashrosejoyce/rainbowroadbook' && assertion.ref=='refs/heads/main'"

  attribute_mapping = {
    "attribute.repository" = "assertion.repository"
    "google.subject"       = "assertion.sub"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_service_account_iam_member" "wif_impersonation" {
  service_account_id = google_service_account.ci.name
  role                = "roles/iam.workloadIdentityUser"
  member              = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/ashrosejoyce/rainbowroadbook"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_instance_iam_member" "ci_os_admin_login" {
  instance_name = google_compute_instance.app_vm.name
  zone          = google_compute_instance.app_vm.zone
  role          = "roles/compute.osAdminLogin"
  member        = "serviceAccount:${google_service_account.ci.email}"
}

resource "google_compute_instance_iam_member" "ash_os_admin_login" {
  instance_name = google_compute_instance.app_vm.name
  zone          = google_compute_instance.app_vm.zone
  role          = "roles/compute.osAdminLogin"
  member        = "user:ash@rainbowroadbook.org"
}

resource "google_service_account_iam_member" "ci_vm_sa_user" {
  service_account_id = "projects/agile-vortex-508316-k6/serviceAccounts/523773459301-compute@developer.gserviceaccount.com"
  role                = "roles/iam.serviceAccountUser"
  member              = "serviceAccount:${google_service_account.ci.email}"
}

resource "google_project_iam_member" "vm_sql_client" {
  project = "agile-vortex-508316-k6"
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:523773459301-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "vm_sql_instance_user" {
  project = "agile-vortex-508316-k6"
  role    = "roles/cloudsql.instanceUser"
  member  = "serviceAccount:523773459301-compute@developer.gserviceaccount.com"
}

resource "google_iap_tunnel_instance_iam_member" "ci_iap_tunnel_vm" {
  project  = "agile-vortex-508316-k6"
  zone     = "us-central1-a"
  instance = google_compute_instance.app_vm.name
  role     = "roles/iap.tunnelResourceAccessor"
  member   = "serviceAccount:${google_service_account.ci.email}"
}
