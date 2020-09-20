terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.39.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.39.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 2.3.0"
    }
  }
  required_version = ">= 0.13"
}

provider "google" {
  credentials = file(var.account)
  project     = var.project
  region      = var.region
}

provider "google-beta" {
  credentials = file(var.account)
  project     = var.project
  region      = var.region
}
