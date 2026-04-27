terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.29.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "7.29.0"
    }
  }
  backend "gcs" {
    bucket = "catvote2-tfstate"
    prefix = "terraform/state" # path inside the bucket
  }
}

provider "google" {
  project               = var.project_id
  region                = var.region
  zone                  = var.zone
  billing_project       = var.project_id
  user_project_override = true
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
