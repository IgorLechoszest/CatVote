resource "google_firebase_project" "default" {
  provider   = google-beta
  project    = var.project_id
  depends_on = [google_project_service.apis]
}

resource "google_identity_platform_config" "auth" {
  project = var.project_id

  sign_in {
    allow_duplicate_emails = false

    email {
      enabled           = true
      password_required = true
    }
  }

  depends_on = [
    google_firebase_project.default,
    google_project_service.apis,
  ]
}

resource "google_firebase_web_app" "frontend" {
  provider     = google-beta
  project      = var.project_id
  display_name = "CatVote Frontend"
  depends_on   = [google_firebase_project.default]
}

data "google_firebase_web_app_config" "frontend" {
  provider   = google-beta
  web_app_id = google_firebase_web_app.frontend.app_id
  project    = var.project_id
}
