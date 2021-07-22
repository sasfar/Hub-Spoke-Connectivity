resource "google_compute_network" "hub" {
  name                    = "hub-vpc"
  auto_create_subnetworks = false
  project                 = data.google_project.hub.project_id
}

resource "google_compute_subnetwork" "hub-subnet" {
  name          = "hub-subnet01"
  ip_cidr_range = var.hub_subnet_ip_range
  region        = var.region
  network       = google_compute_network.hub.id
  project       = data.google_project.hub.project_id
}