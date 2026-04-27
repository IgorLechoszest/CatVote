output "db_private_ip" {
  value = google_sql_database_instance.postgres.private_ip_address
}

output "db_connection_name" {
  value = google_sql_database_instance.postgres.connection_name
}

output "db_name" {
  value = google_sql_database.main.name
}

output "redis_host" {
  value = google_redis_instance.cache.host
}

output "redis_port" {
  value = google_redis_instance.cache.port
}

output "vpc_connector_id" {
  value = google_vpc_access_connector.connector.id
}

output "frontend_url" {
  value = google_cloud_run_v2_service.frontend.uri
}

output "backend_url" {
  value = google_cloud_run_v2_service.backend.uri
}

output "firebase_web_config" {
  value = {
    api_key             = data.google_firebase_web_app_config.frontend.api_key
    auth_domain         = data.google_firebase_web_app_config.frontend.auth_domain
    project_id          = var.project_id
    storage_bucket      = data.google_firebase_web_app_config.frontend.storage_bucket
    messaging_sender_id = data.google_firebase_web_app_config.frontend.messaging_sender_id
    app_id              = google_firebase_web_app.frontend.app_id
  }
}