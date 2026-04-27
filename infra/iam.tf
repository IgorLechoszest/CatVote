data "google_project" "project" {}

# Fetch function

resource "google_service_account" "fetch" {
  account_id   = "cat-fetch-sa"
  display_name = "Cat Fetch Function"
}

resource "google_storage_bucket_iam_member" "fetch_unfiltered_writer" {
  bucket = google_storage_bucket.unfiltered.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.fetch.email}"
}

resource "google_pubsub_topic_iam_member" "fetch_publisher" {
  topic  = google_pubsub_topic.cat_urls.name
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:${google_service_account.fetch.email}"
}

# Validate function

resource "google_service_account" "validate" {
  account_id   = "cat-validate-sa"
  display_name = "Cat Validate Function"
}

resource "google_storage_bucket_iam_member" "validate_unfiltered_reader" {
  bucket = google_storage_bucket.unfiltered.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.validate.email}"
}

resource "google_storage_bucket_iam_member" "validate_filtered_writer" {
  bucket = google_storage_bucket.filtered.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.validate.email}"
}

resource "google_project_iam_member" "validate_sql" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.validate.email}"
}

# Backend 

resource "google_service_account" "backend" {
  account_id   = "cat-backend-sa"
  display_name = "Cat Backend API"
}

resource "google_project_iam_member" "backend_sql" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.backend.email}"
}

resource "google_storage_bucket_iam_member" "backend_filtered_reader" {
  bucket = google_storage_bucket.filtered.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.backend.email}"
}

# Pub/Sub and Validate invoker

resource "google_service_account" "pubsub_invoker" {
  account_id   = "cat-pubsub-invoker"
  display_name = "Pub/Sub Cloud Run Invoker"
}

# Pub/Sub service agent needs to mint tokens for the invoker SA
resource "google_service_account_iam_member" "pubsub_token_creator" {
  service_account_id = google_service_account.pubsub_invoker.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_cloud_run_v2_service_iam_member" "pubsub_invoke_validate" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.validate.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.pubsub_invoker.email}"
}

# Scheduler and Fetch invoker 

resource "google_service_account" "scheduler_invoker" {
  account_id   = "cat-scheduler-invoker"
  display_name = "Scheduler Cloud Run Invoker"
}

resource "google_cloud_run_v2_service_iam_member" "scheduler_invoke_fetch" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.fetch.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.scheduler_invoker.email}"
}
