resource "google_compute_network" "spoke" {
  name                    = "spoke"
  auto_create_subnetworks = false
  project                 = data.google_project.spoke.project_id
}

resource "google_compute_subnetwork" "spoke-subnet" {
  name          = "spoke-subnet"
  ip_cidr_range = var.spoke_subnet_ip_range
  region        = var.region
  network       = google_compute_network.spoke.id
  project       = data.google_project.spoke.project_id

#  secondary_ip_range = [
#  {
#    range_name    = "pods"
#    ip_cidr_range = var.spoke_subnet_pods_ip_range
#  },
#  {
#    range_name    = "services"
#    ip_cidr_range = var.spoke_subnet_services_ip_range
#  }
#]
}

resource "google_compute_network_peering" "spoke-to-hub" {
  name                 = "spoke-to-hub"
  network              = google_compute_network.spoke.id
  peer_network         = data.google_compute_network.hub.self_link

  export_custom_routes = true 
  import_custom_routes = true
}

# Could be moved to network hub tf
resource "google_compute_network_peering" "hub-to-spoke" {
  name                 = "hub-to-spoke"
  network              = data.google_compute_network.hub.self_link 
  peer_network         = google_compute_network.spoke.id

  export_custom_routes = true
  import_custom_routes = true
}

data "google_compute_network" "hub" {
  name    = "hub"
  project = data.google_project.hub.project_id
}