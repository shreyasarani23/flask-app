# Create VPC
resource "google_compute_network" "test-vpc" {
  name                    = "${var.environment}-vpc"
  project                 = var.project_id
  auto_create_subnetworks = "false"
}

#Create Subnet
resource "google_compute_subnetwork" "test-subnet" {
  name                     = "${var.environment}-subnet"
  project                  = var.project_id
  ip_cidr_range            = "10.178.0.0/20"
  network                  = google_compute_network.test-vpc
  depends_on               = [google_compute_network.test-vpc]
  region                   = var.region
  private_ip_google_access = true
  secondary_ip_range {
    ip_cidr_range = "10.23.0.0/14"
    range_name    = "${var.environment}-pod-subnet"
  }
  secondary_ip_range {
    ip_cidr_range = "10.56.0.0/20"
    range_name    = "${var.environment}-services-subnet"
  }
}