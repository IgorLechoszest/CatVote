locals {
  placeholder_image = "us-docker.pkg.dev/cloudrun/container/hello:latest"
}

# Frontend

resource "google_cloud_run_v2_service" "frontend" {
  name     = "cat-frontend"
  location = var.region

  deletion_protection = false

  template {
    containers {
      image = local.placeholder_image

      env {
        name  = "VITE_API_URL"
        value = google_cloud_run_v2_service.backend.uri
      }
    }
  }

  depends_on = [google_project_service.apis]
}

resource "google_cloud_run_v2_service_iam_member" "frontend_public" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.frontend.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Backend

resource "google_cloud_run_v2_service" "backend" {
  name     = "cat-backend"
  location = var.region

  deletion_protection = false

  template {
    service_account = google_service_account.backend.email

    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress    = "PRIVATE_RANGES_ONLY"
    }

    containers {
      image = local.placeholder_image

      env {
        name  = "DB_HOST"
        value = google_sql_database_instance.postgres.private_ip_address
      }
      env {
        name  = "DB_NAME"
        value = google_sql_database.main.name
      }
      env {
        name  = "DB_USER"
        value = google_sql_user.app.name
      }
      env {
        name  = "DB_PASSWORD"
        value = var.db_password
      }
      env {
        name  = "REDIS_HOST"
        value = google_redis_instance.cache.host
      }
      env {
        name  = "REDIS_PORT"
        value = tostring(google_redis_instance.cache.port)
      }
    }
  }

  depends_on = [
    google_project_service.apis,
    google_service_networking_connection.private_vpc_connection,
  ]
}

resource "google_cloud_run_v2_service_iam_member" "backend_public" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.backend.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Fetch function

resource "google_cloud_run_v2_service" "fetch" {
  name     = "cat-fetch"
  location = var.region

  deletion_protection = false

  template {
    service_account = google_service_account.fetch.email

    containers {
      image = local.placeholder_image

      env {
        name  = "UNFILTERED_BUCKET"
        value = google_storage_bucket.unfiltered.name
      }
      env {
        name  = "PUBSUB_TOPIC_ID"
        value = google_pubsub_topic.cat_urls.id
      }
    }
  }

  depends_on = [google_project_service.apis]
}

# Validate function

resource "google_cloud_run_v2_service" "validate" {
  name     = "cat-validate"
  location = var.region

  deletion_protection = false

  template {
    service_account = google_service_account.validate.email

    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress    = "PRIVATE_RANGES_ONLY"
    }

    containers {
      image = local.placeholder_image

      env {
        name  = "UNFILTERED_BUCKET"
        value = google_storage_bucket.unfiltered.name
      }
      env {
        name  = "FILTERED_BUCKET"
        value = google_storage_bucket.filtered.name
      }
      env {
        name  = "DB_HOST"
        value = google_sql_database_instance.postgres.private_ip_address
      }
      env {
        name  = "DB_NAME"
        value = google_sql_database.main.name
      }
      env {
        name  = "DB_USER"
        value = google_sql_user.app.name
      }
      env {
        name  = "DB_PASSWORD"
        value = var.db_password
      }
    }
  }

  depends_on = [
    google_project_service.apis,
    google_service_networking_connection.private_vpc_connection,
  ]
}