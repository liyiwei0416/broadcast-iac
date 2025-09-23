terraform {
  required_providers {
    nxos = {
      source = "CiscoDevNet/nxos"
      version = "0.5.10"
    }
  }
}

provider "nxos" {
  username = "admin"
  password = "IPLive123!"
  url      = "https://192.168.100.6"
}

resource "nxos_physical_interface" "eth1-1" {
  interface_id = "eth1/1"
  description = "Configured by Terraform"
  admin_state  = "up"
  layer = "Layer3"
  uni_directional_ethernet = "disable"
}
