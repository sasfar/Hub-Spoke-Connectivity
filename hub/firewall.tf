resource "google_compute_firewall" "allow-ingress-traffic-from-vpn" {
  name        = "allow-ingress-traffic-to-vpn"
  network     = google_compute_network.hub.name
  project     = data.google_project.hub.project_id

  allow {
    protocol  = "tcp"
  }

  source_ranges = split("," ,var.on_premise_network_ip_range)
  priority    = 1000
  direction   = "INGRESS"
}

resource "google_compute_firewall" "allow-egress-traffic-to-vpn" {
  name        = "allow-egress-traffic-to-vpn"
  network     = google_compute_network.hub.name
  project     = data.google_project.hub.project_id

  allow {
    protocol  = "tcp"
  }

  destination_ranges = split("," ,var.on_premise_network_ip_range)
  priority    = 1000
  direction   = "EGRESS"
}

resource "google_compute_firewall" "deny-ingress-traffic-from-internet" {
  name    = "deny-all-ingress-traffic"
  network = google_compute_network.hub.name
  project = data.google_project.hub.project_id

  deny {
    protocol  = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  priority      = 2000
  direction     = "INGRESS"
}
resource "google_compute_firewall" "deny-egress-traffic-to-internet" {
  name    = "deny-all-egress-traffic"
  network = google_compute_network.hub.name
  project = data.google_project.hub.project_id

  allow {
    protocol  = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
  priority    = 2000
  direction   = "EGRESS"
}
