variable "region" {
  type = string
  default = "us-east4"
}

variable "spoke_subnet_ip_range" {
  type = string
} 

#variable "spoke_subnet_pods_ip_range" {
#  type = string
#} 
#variable "spoke_subnet_services_ip_range" {
#  type = string
#} 
variable "env" {
  type = string
}