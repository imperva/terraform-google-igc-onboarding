module "igc_customer_onboarding_glb_multi" {
source = "git::ssh://git@gitlab/devops/iac/terraform-modules/igc-customer-onboarding.git?ref=tf_examples"

  project_id = "cpl-vpop-l-app-demo-01"
  global_backend_service_name = "mor-bcs"
  global_network_services_lb_traffic_extension_name = "mor-global-en"

  global_resources = [
    {
      load_balancer_name = "igc-mt-56951147-global"
      authority_header   = "1b31cdc2-0dc7-43e9-9c84-cac862b50925-56951147.impervagcp.com"
      forwarding_rules   = ["igc-mt-56951147-global-forwarding-rule", "igc-mt-56951147-global-https-forwarding-rule"]
      imperva_backends = [
        {
          region  = "asia-southeast1"
          network = "cpl-vpc-demo1"
          subnet  = "cpl-subnet-asia-southeast1-demo1"
        },
        {
          region  = "us-west2"
          network = "cpl-vpc-demo1"
          subnet  = "cpl-subnet-us-west2-demo1"
        }
      ]
      extention_metadata = {
        lb-id      = "igc-mt-56951147-regional"
        project-id = "cpl-vpop-l-app-demo-01"
      }
    }
  ]
}
