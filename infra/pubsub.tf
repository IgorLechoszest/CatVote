resource "google_pubsub_topic" "cat_urls" {
  name = "cat-urls"
}

resource "google_pubsub_subscription" "validate" {
  name                 = "validate-sub"
  topic                = google_pubsub_topic.cat_urls.name
  ack_deadline_seconds = 60
}