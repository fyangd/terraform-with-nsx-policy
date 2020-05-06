# NSX-T Automation with Terraform

- Examples here uses NSX-T Policy API. 


## Iteration 1 

This example implements an active / standby Tier 0 configuration with Tier 1 and an overlay segment attached to Tier 1. The overlay segment has a DHCP configured. For now there does not seem to be support for HA VIP config on Tier 0. Hence that needs to be configured manually.

![]()
