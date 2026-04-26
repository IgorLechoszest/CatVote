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

resource "google_pubsub_topic" "cat_urls" {
  name = "cat-urls"
}

resource "google_pubsub_subscription" "validate" {
  name                 = "validate-sub"
  topic                = google_pubsub_topic.cat_urls.name
  ack_deadline_seconds = 60
}