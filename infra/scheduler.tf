resource "google_cloud_scheduler_job" "fetch" {
  name      = "cat-fetch-scheduler"
  schedule  = "0 9 * * *"
  time_zone = "UTC"
  region    = var.region

  http_target {
    http_method = "POST"
    uri         = "${google_cloud_run_v2_service.fetch.uri}/fetch"

    oidc_token {
      service_account_email = google_service_account.scheduler_invoker.email
    }
  }

  depends_on = [google_project_service.apis]
}
