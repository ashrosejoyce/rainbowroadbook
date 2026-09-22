import {
  to = google_artifact_registry_repository.images
  id = "projects/agile-vortex-508316-k6/locations/us-central1/repositories/rainbowroadbook-images"
}

import {
  to = google_secret_manager_secret.django_secret_key
  id = "projects/agile-vortex-508316-k6/secrets/rainbowroadbook-django-secret-key"
}

import {
  to = google_compute_address.app_ip
  id = "projects/agile-vortex-508316-k6/regions/us-central1/addresses/rainbowroadbook-app-ip"
}

import {
  to = google_compute_firewall.allow_iap_ssh
  id = "projects/agile-vortex-508316-k6/global/firewalls/rainbowroadbook-allow-iap-ssh"
}

import {
  to = google_service_account.ci
  id = "projects/agile-vortex-508316-k6/serviceAccounts/rainbowroadbook-ci@agile-vortex-508316-k6.iam.gserviceaccount.com"
}

import {
  to = google_artifact_registry_repository_iam_member.ci_writer
  id = "projects/agile-vortex-508316-k6/locations/us-central1/repositories/rainbowroadbook-images roles/artifactregistry.writer serviceAccount:rainbowroadbook-ci@agile-vortex-508316-k6.iam.gserviceaccount.com"
}

import {
  to = google_artifact_registry_repository_iam_member.vm_reader
  id = "projects/agile-vortex-508316-k6/locations/us-central1/repositories/rainbowroadbook-images roles/artifactregistry.reader serviceAccount:523773459301-compute@developer.gserviceaccount.com"
}

import {
  to = google_secret_manager_secret_iam_member.vm_secret_accessor
  id = "projects/agile-vortex-508316-k6/secrets/rainbowroadbook-django-secret-key roles/secretmanager.secretAccessor serviceAccount:523773459301-compute@developer.gserviceaccount.com"
}

import {
  to = google_project_iam_custom_role.ci_ssh_discovery
  id = "projects/agile-vortex-508316-k6/roles/rainbowroadbook_ci_ssh_discovery"
}

import {
  to = google_project_iam_member.ci_ssh_discovery
  id = "agile-vortex-508316-k6 projects/agile-vortex-508316-k6/roles/rainbowroadbook_ci_ssh_discovery serviceAccount:rainbowroadbook-ci@agile-vortex-508316-k6.iam.gserviceaccount.com"
}

import {
  to = google_iam_workload_identity_pool.github
  id = "projects/agile-vortex-508316-k6/locations/global/workloadIdentityPools/rainbowroadbook-github"
}

import {
  to = google_iam_workload_identity_pool_provider.github_actions
  id = "projects/agile-vortex-508316-k6/locations/global/workloadIdentityPools/rainbowroadbook-github/providers/rainbowroadbook-github-actions"
}

import {
  to = google_service_account_iam_member.wif_impersonation
  id = "projects/agile-vortex-508316-k6/serviceAccounts/rainbowroadbook-ci@agile-vortex-508316-k6.iam.gserviceaccount.com roles/iam.workloadIdentityUser principalSet://iam.googleapis.com/projects/523773459301/locations/global/workloadIdentityPools/rainbowroadbook-github/attribute.repository/ashrosejoyce/rainbowroadbook"
}

import {
  to = google_compute_instance.app_vm
  id = "projects/agile-vortex-508316-k6/zones/us-central1-a/instances/rainbowroadbook-app-vm"
}

import {
  to = google_compute_instance_iam_member.ci_os_admin_login
  id = "projects/agile-vortex-508316-k6/zones/us-central1-a/instances/rainbowroadbook-app-vm roles/compute.osAdminLogin serviceAccount:rainbowroadbook-ci@agile-vortex-508316-k6.iam.gserviceaccount.com"
}

import {
  to = google_compute_instance_iam_member.ash_os_admin_login
  id = "projects/agile-vortex-508316-k6/zones/us-central1-a/instances/rainbowroadbook-app-vm roles/compute.osAdminLogin user:ash@rainbowroadbook.org"
}

import {
  to = google_service_account_iam_member.ci_vm_sa_user
  id = "projects/agile-vortex-508316-k6/serviceAccounts/523773459301-compute@developer.gserviceaccount.com roles/iam.serviceAccountUser serviceAccount:rainbowroadbook-ci@agile-vortex-508316-k6.iam.gserviceaccount.com"
}

import {
  to = google_project_iam_member.vm_sql_client
  id = "agile-vortex-508316-k6 roles/cloudsql.client serviceAccount:523773459301-compute@developer.gserviceaccount.com"
}

import {
  to = google_project_iam_member.vm_sql_instance_user
  id = "agile-vortex-508316-k6 roles/cloudsql.instanceUser serviceAccount:523773459301-compute@developer.gserviceaccount.com"
}

import {
  to = google_sql_database_instance.db
  id = "agile-vortex-508316-k6/rainbow-roadbook-db"
}

import {
  to = google_sql_database.prod
  id = "agile-vortex-508316-k6/rainbow-roadbook-db/rainbowroadbook_prod"
}

import {
  to = google_sql_user.ash
  id = "agile-vortex-508316-k6/rainbow-roadbook-db/ash"
}

import {
  to = google_sql_user.app
  id = "agile-vortex-508316-k6/rainbow-roadbook-db/rainbowroadbook_app"
}

import {
  to = google_sql_user.vm_iam
  id = "agile-vortex-508316-k6/rainbow-roadbook-db/523773459301-compute@developer"
}
