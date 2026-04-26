terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
  backend "gcs" {
    bucket  = "project-9d931bae-c4eb-4690-9cd-tfstate"
    prefix  = "terraform/state"   # path inside the bucket
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
