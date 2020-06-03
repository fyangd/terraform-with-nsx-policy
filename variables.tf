variable "nsx_vars" {
    type = map(string)
    default = {
        overlay_tz = "tz-overlay"
        vlan_tz = "internet-tz-vlan-0"
        edge_cluster = "edge-cluster-0"
        edge_node_first = "tn-cluster-0-edge-0"

        vlan_uplink_segment_name = "uplink_segment"
        vlan_uplink_segment_vlanid = "101"

        tier0_name = "tier0-demo"
        tier0_uplink_edge_node_first_ip="192.168.115.123/24"
        tier0_default_route_next_hop_ip="192.168.115.1"

        tier1_name = "tier1-demo"
        tier1_segment1_name="workload_segment1"
        tier1_segment1_ip="12.10.10.1/24"
        tier1_segment1_dhcp_range="12.10.10.51-12.10.10.99"
        tier1_segment1_dns_server_ip="192.168.111.155"

        bootstrap = "sudo ip route delete 12.10.10.0/24 ; sudo route add -net 12.10.10.0/24 gw 192.168.115.123"
    }
}
