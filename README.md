# NSX-T Automation with Terraform

Examples here uses NSX-T Policy API. 

In all iterations, at the end of the Terraform script, there is a static route added to the Ubuntu host which is basically a VM connected to the same VLAN which the Tier0 uplink is connected to. It is purely optional and that section can be deleted if desired.


## Iteration 2

This example implements an active / standby Tier 0 configuration with Tier 1 and an overlay segment attached to Tier 1. The overlay segment has a DHCP configured. For now there does not seem to be support for HA VIP config on Tier 0. Hence that needs to be configured manually.

![](Topology.png)


## Iteration-TKG

This example also provisions the same topology as iteration 1 and 2, however it has the Github based binaries for NSX Plugin for Terraform and configures the environment for VNware TKG installation. It usese VLAN ID = 0 for Tier 0 uplink vlan segment. Credit goes to [@jayunit100](https://github.com/jayunit100)
