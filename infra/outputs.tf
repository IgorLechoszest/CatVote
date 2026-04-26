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