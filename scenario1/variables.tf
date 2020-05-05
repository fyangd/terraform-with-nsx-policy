variable "nsx_manager_ip" {
    default = "10.79.1.10"
}

variable "nsx_username" {
  default = "admin"
}
 
variable "nsx_password" {
    default = "VMwareD1!VMwareD1!"
}

variable "overlay_tz" {
    # type = string
    default = "nsx-overlay-transportzone"
}

variable "vlan_tz" {
    # type = string
    default = "nsx-vlan-transportzone"
}

variable "edge_node_first" {
    default = "edge03"
}
variable "edge_node_second" {
    default = "edge04"
}

variable "edge_cluster" {
    default = "EdgeCluster2"
}

variable "vlan_uplink_segment" {
    default = "uplink_segment"
}

variable "tier0" {
    default = "tier0_demo"
}

variable "tier1" {
    default = "tier1_demo"
}

variable "tkg_segment" {
    default = "tkg_overlay_segment" 
}
