resource "google_sql_database_instance" "postgres" {
  name             = "cat-app-pg"
  database_version = "POSTGRES_16"
  region           = var.region

  # Wait for the private network to be ready
  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = "db-f1-micro"
    availability_type = "ZONAL"
    disk_size         = 10
    disk_type         = "PD_HDD"

    ip_configuration {
      ipv4_enabled    = false # no public IP, private only
      private_network = google_compute_network.vpc.id
    }

    backup_configuration {
      enabled    = true
      start_time = "03:00"
    }
  }

  deletion_protection = false # easy terraform destroy later
}

# A database inside the instance (instance = the server, database = the actual DB)
resource "google_sql_database" "main" {
  name     = "catapp"
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "app" {
  name     = "appuser"
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
}