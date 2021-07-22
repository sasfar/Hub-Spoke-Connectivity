/*resource "google_compute_vpn_tunnel" "tunnel" {
  name                    = "tunnel"
  peer_ip                 = var.on_premise_peer_ip
  shared_secret           = data.google_secret_manager_secret_version.vpn-shared-secret.secret_data
  project                 = data.google_project.hub.project_id
  ike_version             = 2
  remote_traffic_selector = split("," ,var.on_premise_network_ip_range)
  local_traffic_selector  = [var.hub_subnet_ip_range]
  target_vpn_gateway      = google_compute_vpn_gateway.target_gateway.id
  region                  = var.region

  depends_on = [
    google_compute_forwarding_rule.fr_esp,
    google_compute_forwarding_rule.fr_udp500,
    google_compute_forwarding_rule.fr_udp4500,
  ]
}

resource "google_compute_ha_vpn_gateway" "ha_gateway1" {
  name    = "vpn"
  network = google_compute_network.hub.id
  project = data.google_project.hub.project_id
  region  = var.region
}

resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = data.google_compute_address.vpn-static-ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
  project     = data.google_project.hub.project_id
  region      = var.region
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = data.google_compute_address.vpn-static-ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
  project     = data.google_project.hub.project_id
  region      = var.region
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = data.google_compute_address.vpn-static-ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
  project     = data.google_project.hub.project_id
  region      = var.region
}

resource "google_compute_route" "route" {
  name       = "route"
  network    = google_compute_network.hub.name
  project    = data.google_project.hub.project_id
  dest_range = "192.168.68.0/24"
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel.id
}

resource "google_compute_route" "route1" {
  name       = "route1"
  network    = google_compute_network.hub.name
  project    = data.google_project.hub.project_id
  dest_range = "192.168.1.0/24"
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel.id
}

data "google_secret_manager_secret_version" "vpn-shared-secret" {
  project = data.google_project.hub.project_id
  secret  = "vpn-shared-secret"
}

data "google_compute_address" "vpn-static-ip" {
  project = data.google_project.hub.project_id
  name    = "vpn-static-ip"
  region  = var.region
}
*/
module "vpn_ha" {
  source = "terraform-google-modules/vpn/google//modules/vpn_ha"
  project_id  = "sada-gcve-demo-hub"
  region  = "us-east4"
  network         = "https://www.googleapis.com/compute/v1/projects/sada-gcve-demo-hub/global/networks/hub-vpc"
  name            = "gcp-ha-on-prem"
  peer_external_gateway = {
      redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
      interfaces = [{
          id = 0
          ip_address = "99.231.116.38" # on-prem router ip address

      }]
  }
  router_asn = 16550
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.0.1"
        asn     = 64513
      }
      bgp_peer_options  = null
      bgp_session_range = "169.254.0.2/30"
      ike_version       = 2
      vpn_gateway_interface = 0
      peer_external_gateway_interface = 0
      shared_secret     = "SamplePassword"
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_peer_options  = null
      bgp_session_range = "169.254.2.2/30"
      ike_version       = 2
      vpn_gateway_interface = 1
      peer_external_gateway_interface = 0
      shared_secret     = "SamplePassword"
    }
  }
}
