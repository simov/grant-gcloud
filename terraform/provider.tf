terraform {
  required_version = ">= 0.12"
}

provider "google" {
  credentials = file(var.account)
  project     = var.project
  region      = var.region
}
