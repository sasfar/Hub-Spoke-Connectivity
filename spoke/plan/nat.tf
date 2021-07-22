resource "google_compute_router" "router" {
  name    = "router"
  region  = google_compute_subnetwork.spoke-subnet.region
  network = google_compute_network.spoke.id
  project = data.google_project.spoke.project_id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name    = "nat"
  router  = google_compute_router.router.name
  region  = google_compute_router.router.region
  project = data.google_project.spoke.project_id

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = [data.google_compute_address.nat-static-ip1.self_link, data.google_compute_address.nat-static-ip2.self_link]

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

data "google_compute_address" "nat-static-ip1" {
  project = data.google_project.spoke.project_id
  name    = "nat-static-ip1"
  region  = var.region
}

data "google_compute_address" "nat-static-ip2" {
  project = data.google_project.spoke.project_id
  name    = "nat-static-ip2"
  region  = var.region
}