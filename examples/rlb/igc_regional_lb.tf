module "igc_customer_onboarding_rlb" {
  source = "git::ssh://git@gitlab/devops/iac/terraform-modules/igc-customer-onboarding.git"

  project_id = "cpl-vpop-l-app-demo-01"

  regional_resources = [
    {
      load_balancer_name = "igc-mt-56951147-regional"
      region             = "asia-southeast1"
      network            = "cpl-vpc-demo1"
      subnet             = "cpl-subnet-asia-southeast1-demo1"
      authority_header   = "1b31cdc2-0dc7-43e9-9c84-cac862b50925-56951147.impervagcp.com"
      forwarding_rules   = ["igc-mt-56951147-f-rule-asia-southeast1"]
      extention_metadata = {
        lb-id      = "igc-mt-56951147-regional"
        project-id = "cpl-vpop-l-app-demo-01"
      }
    }
  ]

}
