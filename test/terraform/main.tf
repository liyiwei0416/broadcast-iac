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
  password = "Video@123"
  url      = "https://10.205.1.221"
}

// Enable required features

resource "nxos_feature_ospf" "ospf" {
  admin_state = "enabled"
}

resource "nxos_feature_pim" "pim" {
  admin_state = "enabled"
}

resource "nxos_feature_ptp" "ptp" {
  admin_state = "enabled"
}

// Interface Configuration

resource "nxos_ipv4_vrf" "vrf" {
  name="default"
}

resource "nxos_physical_interface" "eth1-1" {
  interface_id = "eth1/2"
  description = "Configured by Terraform"
  admin_state  = "up"
  layer = "Layer3"
}

resource "nxos_ipv4_interface" "eth1-1_interface" {
  interface_id = "eth1/2"
  vrf          = "default"
  depends_on = [ nxos_ipv4_vrf.vrf]
}

resource "nxos_ipv4_interface_address" "eth1-1_ip" {
  interface_id = "eth1/2"
  address      = "192.0.2.1/30"
  vrf          = "default"
  depends_on = [ nxos_ipv4_interface.eth1-1_interface ]
}


// OSPF Configuration

resource "nxos_ospf" "nxos_ospf" {
  admin_state = "enabled"
}

resource "nxos_ospf_instance" "ospf_instance" {
  admin_state = "enabled"
  name        = "100"
  depends_on = [ nxos_ospf.nxos_ospf ]
}

resource "nxos_ospf_vrf" "ospf_vrf" {
  instance_name            = "100"
  name                     = "default"
  admin_state              = "enabled"
  router_id                = "1.1.1.1"
  depends_on = [ nxos_ospf_instance.ospf_instance ]
}

resource "nxos_ospf_interface" "ospf_eth1-1" {
  instance_name         = "100"
  vrf_name              = "default"
  interface_id          = "eth1/2"
  area                  = "0.0.0.0"
  passive               = "enabled"
  depends_on = [ nxos_ospf_vrf.ospf_vrf ]
}


// PIM Configuration

resource "nxos_pim" "nxos_pim" {
  admin_state = "enabled"
}

resource "nxos_pim_instance" "pim_instance" {
  admin_state = "enabled"
  depends_on = [ nxos_pim.nxos_pim ]
}

resource "nxos_pim_vrf" "pim_vrf" {
  name        = "default"
  admin_state = "enabled"
  depends_on = [ nxos_pim_instance.pim_instance ]
}

resource "nxos_pim_interface" "pim_eth1-1" {
  vrf_name     = "default"
  interface_id = "eth1/2"
  admin_state  = "enabled"
  passive      = true
  sparse_mode  = true
  depends_on = [ nxos_pim_instance.pim_instance ]
}

// Save Configuration

resource "nxos_save_config" "save" {
}