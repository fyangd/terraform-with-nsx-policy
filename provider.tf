provider "nsxt" {
    host                     = "nsxmanager.pks.vmware.local" 
    username                 = "admin"
    password                 = "Admin!23Admin"
    allow_unverified_ssl     = true
    max_retries              = 10
    retry_min_delay          = 500
    retry_max_delay          = 5000
    retry_on_status_codes    = [429]
}
