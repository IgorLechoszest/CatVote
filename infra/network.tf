# The private network itself
resource "google_compute_network" "vpc" {
  name                    = "cat-app-vpc"
  auto_create_subnetworks = false
}

# A subnet inside the VPC (Cloud SQL needs the VPC, the subnet is for the connector)
resource "google_compute_subnetwork" "subnet" {
  name          = "cat-app-subnet"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Reserve an IP range for Google's managed services (Cloud SQL, Redis)
resource "google_compute_global_address" "private_ip_range" {
  name          = "cat-app-private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

# Connect Google's services network to your VPC using that range
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
}

# Connector that lets Cloud Run reach the VPC
resource "google_vpc_access_connector" "connector" {
  name          = "cat-app-connector"
  region        = var.region
  ip_cidr_range = "10.20.0.0/28"
  network       = google_compute_network.vpc.name
  min_instances = 2
  max_instances = 3
}