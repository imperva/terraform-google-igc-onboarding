output "imperva_network_endpoint_groups" {
  description = "Imperva For Google Cloud Platform Network Endpoint Groups"
  value       = [for neg in google_compute_region_network_endpoint_group.imperva_connector_neg : neg.name]
}

output "imperva_regional_backend_services" {
  description = "Imperva For Google Cloud Platform Regional Backend Services"
  value       = [for bs in google_compute_region_backend_service.imperva_connector_backend : bs.name]
}

output "imperva_global_backend_services" {
  description = "Imperva For Google Cloud Platform Regional Backend Services"
  value       = [for bs in google_compute_backend_service.imperva_connector_backend_global : bs.name]
}

output "protected_forwarding_rules" {
  description = "Forwarding rules protected by Imperva For Google Cloud Platform"
  value       = flatten(concat([for res in google_network_services_lb_traffic_extension.imperva_traffic_extension_global : res.forwarding_rules], [for res in google_network_services_lb_traffic_extension.imperva_traffic_extension_regional : res.forwarding_rules]))
}
