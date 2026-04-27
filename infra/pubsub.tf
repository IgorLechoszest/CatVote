resource "google_pubsub_topic" "cat_urls" {
  name = "cat-urls"
}

resource "google_pubsub_subscription" "validate" {
  name  = "validate-sub"
  topic = google_pubsub_topic.cat_urls.name

  push_config {
    push_endpoint = "${google_cloud_run_v2_service.validate.uri}/process"

    oidc_token {
      service_account_email = google_service_account.pubsub_invoker.email
    }
  }

  ack_deadline_seconds = 60
}