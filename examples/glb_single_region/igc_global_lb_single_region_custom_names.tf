module "igc_customer_onboarding_glb_single" {
  source = "git::ssh://git@gitlab/devops/iac/terraform-modules/igc-customer-onboarding.git?ref=tf_examples"

  project_id = "cpl-vpop-l-app-demo-01"
  global_backend_service_name = "test-bcs"
  global_network_services_lb_traffic_extension_name = "test-global-en"
  network_endpoint_group_name = "test-nsg"
  global_resources = [
    {
      load_balancer_name = "igc-mt-56526147-global"
      authority_header   = "5626bac2-cf74-4954-b766-2665f3a0c3ed-56526147.impervagcp.com"
      forwarding_rules   = ["igc-mt-56526147-global-forwarding-rule", "igc-mt-56526147-global-https-forwarding-rule"]
      imperva_backends = [
        {
          region  = "asia-southeast1"
          network = "cpl-vpc-demo1"
          subnet  = "cpl-subnet-asia-southeast1-demo1"
        }
      ]
      extention_metadata = {
        lb-id      = "igc-mt-56526147-regional"
        project-id = "cpl-vpop-l-app-demo-01"
      }
    }
  ]
}
