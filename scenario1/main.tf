data "nsxt_policy_transport_zone" "overlay_tz" {
    display_name         = var.overlay_tz
}
 
data "nsxt_policy_transport_zone" "vlan_tz" {
    display_name         = var.vlan_tz
}
 
data "nsxt_policy_edge_cluster" "edge_cluster" {
    display_name         = var.edge_cluster
}

data "nsxt_policy_edge_node" "edge_node_first" {
    edge_cluster_path    = data.nsxt_policy_edge_cluster.edge_cluster.path
    display_name         = var.edge_node_first
}

data "nsxt_policy_edge_node" "edge_node_second" {
    edge_cluster_path    = data.nsxt_policy_edge_cluster.edge_cluster.path
    display_name         = var.edge_node_second
}

resource "nsxt_policy_vlan_segment" "uplink_vlan" {
  display_name           = var.vlan_uplink_segment
  description            = "Uplink of Tier0 by Terraform"
  vlan_ids               = ["40"]
  # connectivity_path    = nsxt_policy_tier1_gateway.t1_gateway.path
  transport_zone_path    = data.nsxt_policy_transport_zone.vlan_tz.path
}

resource "nsxt_policy_tier0_gateway" "tier0_new" {
    display_name              = var.tier0
    description               = "Tier-0 provisioned by Terraform"
    failover_mode             = "NON_PREEMPTIVE"
    default_rule_logging      = false
    enable_firewall           = false
    force_whitelisting        = true
    ha_mode                   = "ACTIVE_STANDBY"
    edge_cluster_path         = data.nsxt_policy_edge_cluster.edge_cluster.path
 
    tag {
        scope = "demo"
        tag   = "tftest"
    }
}

resource "nsxt_policy_tier0_gateway_interface" "uplink1edge1" {
    display_name        = "Uplink1Edge1"
    #  description         = "Uplink to VLANXXX"
    type                = "EXTERNAL"
    edge_node_path      = data.nsxt_policy_edge_node.edge_node_first.path
    gateway_path        = nsxt_policy_tier0_gateway.tier0_new.path
    segment_path        = nsxt_policy_vlan_segment.uplink_vlan.path
    subnets             = ["10.79.4.201/24"]
    mtu                 = 1500
}
 
resource "nsxt_policy_tier0_gateway_interface" "uplink2" {
    display_name        = "Uplink1Edge2"
    # description         = "Uplink to VLANXXX"
    type                = "EXTERNAL"
    edge_node_path      = data.nsxt_policy_edge_node.edge_node_second.path
    gateway_path        = nsxt_policy_tier0_gateway.tier0_new.path
    segment_path        = nsxt_policy_vlan_segment.uplink_vlan.path
    subnets             = ["10.79.4.202/24"]
    mtu                 = 1500
}

resource "nsxt_policy_static_route" "default_route" {
  display_name = "default"
  gateway_path = nsxt_policy_tier0_gateway.tier0_new.path
  network      = "0.0.0.0/0"

  next_hop {
    admin_distance = "1"
    ip_address     = "10.79.4.1"
  }

  tag {
    scope = "demo"
    tag   = "tftest"
  }
}

resource "nsxt_policy_dhcp_server" "tier_dhcp" {
  display_name     = "DhcpServer"
  description      = "DHCP server for the Tier1"
  edge_cluster_path = data.nsxt_policy_edge_cluster.edge_cluster.path
  server_addresses = ["100.94.0.1/30"]
}

resource "nsxt_policy_tier1_gateway" "tier1_new" {
    display_name                = var.tier1
    description                 = "Tier-1 provisioned by Terraform"
    # edge_cluster_path         = data.nsxt_policy_edge_cluster.edge_cluster.path
    # failover_mode             = "NON_PREEMPTIVE"
    # default_rule_logging      = "false"
    # enable_firewall           = "true"
    # enable_standby_relocation = "false"
    # force_whitelisting        = "true"
    dhcp_config_path            = nsxt_policy_dhcp_server.tier_dhcp.path
    tier0_path                  = nsxt_policy_tier0_gateway.tier0_new.path
    route_advertisement_types   = ["TIER1_CONNECTED"]
 
    tag {
        scope = "demo"
        tag   = "tftest"
    }
 
    # route_advertisement_rule {
    #    name                      = "Tier 1 Networks"
    #    action                    = "PERMIT"
    #    subnets                   = ["10.10.10.0/24", "10.20.20.0/24"]
    #    prefix_operator           = "GE"
    #    route_advertisement_types = ["TIER1_CONNECTED"]
    #}
}

resource "nsxt_policy_segment" "tier1_new_segment1" {
    display_name        = var.tkg_segment
    description         = "Segment created by Terraform"
    transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path
    connectivity_path   = nsxt_policy_tier1_gateway.tier1_new.path
 
    subnet {   
        cidr        = "10.10.10.1/24"
        dhcp_ranges = ["10.10.10.51-10.10.10.99"] 
     
   
        dhcp_v4_config {
             lease_time  = 36000
             dns_servers = ["192.168.1.185"]
        }
    }
}
