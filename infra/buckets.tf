resource "google_storage_bucket" "unfiltered" {
  name                        = "${var.project_id}-cats-unfiltered"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket" "filtered" {
  name                        = "${var.project_id}-cats-filtered"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true
}
