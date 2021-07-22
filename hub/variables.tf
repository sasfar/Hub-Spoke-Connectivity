variable "hub_subnet_ip_range" {
  type    = string
} 

variable "region" {
  type = string
  default = "us-east4"
}

variable "on_premise_network_ip_range" {
  type = string
}

variable "on_premise_peer_ip" {
  type = string
}