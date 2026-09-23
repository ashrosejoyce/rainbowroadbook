variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "agile-vortex-508316-k6"
}

variable "project_number" {
  description = "GCP project number - used to build the default Compute Engine service account email and the VM's Cloud SQL IAM username"
  type        = string
  default     = "523773459301"
}

variable "region" {
  description = "Default GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Default GCP zone for the app VM"
  type        = string
  default     = "us-central1-a"
}

variable "github_repo" {
  description = "GitHub repo (owner/name) trusted to authenticate as the CI service account"
  type        = string
  default     = "ashrosejoyce/rainbowroadbook"
}

locals {
  vm_service_account_email = "${var.project_number}-compute@developer.gserviceaccount.com"
  vm_iam_db_user            = "${var.project_number}-compute@developer"
}
