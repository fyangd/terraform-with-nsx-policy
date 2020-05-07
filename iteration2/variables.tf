variable "nsx_vars" {
    type = map(string)
    default = {
        nsx_manager_ip="10.79.1.10"
        nsx_manager_user="admin"
        nsx_manager_password="VMware1!"
        overlay_tz = "nsx-overlay-transportzone"
        vlan_tz = "nsx-vlan-transportzone"
        edge_cluster = "EdgeCluster2"
        edge_node_first = "edge03"
        edge_node_second = "edge04"
        vlan_uplink_segment_name = "uplink_segment"
        vlan_uplink_segment_vlanid = "40"
        tier0_name = "tier0-demo"
        tier0_uplink_edge_node_first_ip="10.79.4.201/24"
        tier0_uplink_edge_node_second_ip="10.79.4.202/24"
        tier0_default_route_next_hop_ip="10.79.4.1"
        tier1_name = "tier1-demo"
        tier1_segment1_name="workload_segment1"
        tier1_segment1_ip="10.10.10.1/24"
        tier1_segment1_dhcp_range="10.10.10.51-10.10.10.99"
        tier1_segment1_dns_server_ip="192.168.1.185"
    }
}
