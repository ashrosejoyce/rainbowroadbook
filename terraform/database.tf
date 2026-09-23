resource "google_sql_database_instance" "db" {
  name             = "rainbow-roadbook-db"
  database_version = "POSTGRES_18"
  region           = "us-central1"

  settings {
    tier              = "db-f1-micro"
    edition           = "ENTERPRISE"
    availability_type = "ZONAL"
    disk_size         = 10
    disk_type         = "PD_SSD"
    disk_autoresize   = true

    backup_configuration {
      enabled                        = false
      start_time                     = "17:00"
      transaction_log_retention_days = 7
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }

    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }

    ip_configuration {
      ipv4_enabled = true
      ssl_mode     = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    }

    location_preference {
      zone = "us-central1-c"
    }

    deletion_protection_enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_sql_database" "prod" {
  name     = "rainbowroadbook_prod"
  instance = google_sql_database_instance.db.name

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_sql_user" "ash" {
  name     = "ash"
  instance = google_sql_database_instance.db.name

  lifecycle {
    ignore_changes = [password]
  }
}

resource "google_sql_user" "app" {
  name     = "rainbowroadbook_app"
  instance = google_sql_database_instance.db.name

  lifecycle {
    ignore_changes = [password]
  }
}

resource "google_sql_user" "vm_iam" {
  name     = "523773459301-compute@developer"
  instance = google_sql_database_instance.db.name
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
}