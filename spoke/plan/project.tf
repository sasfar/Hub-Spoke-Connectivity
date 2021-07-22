data "google_project" "spoke" {
   project_id = "sada-gcve-demo-${var.env}"
}

data "google_project" "hub" {
   project_id = "sada-gcve-demo-hub"
}

resource "google_compute_shared_vpc_host_project" "host" {
  project = data.google_project.spoke.project_id
}