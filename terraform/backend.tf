terraform {
  backend "gcs" {
    bucket = "rainbowroadbook-terraform-state"
    prefix = "prod"
  }
}
