provider "nsxt" {
    host                     = var.nsx_vars.nsx_manager_ip
    username                 = var.nsx_vars_nsx_manager_username
    password                 = var.nsx_vars_nsx_manager_password
    allow_unverified_ssl     = true
    max_retries              = 10
    retry_min_delay          = 500
    retry_max_delay          = 5000
    retry_on_status_codes    = [429]
}
