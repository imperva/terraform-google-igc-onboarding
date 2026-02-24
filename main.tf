
resource "google_compute_region_network_endpoint_group" "imperva_connector_neg" {
  for_each = {
    for neg in local.all_neg_definitions :
    (
      var.network_endpoint_group_name != null && var.network_endpoint_group_name != ""
      ? var.network_endpoint_group_name
      : (
        neg.suffix_name != null && neg.suffix_name != ""
        ? "${var.prefix}-neg-${neg.region}-${neg.suffix_name}"
        : "${var.prefix}-neg-${neg.region}"
      )
    ) => neg
  }
  name                  = each.key
  network               = each.value.network
  subnetwork            = each.value.subnet
  network_endpoint_type = "PRIVATE_SERVICE_CONNECT"
  psc_target_service    = each.value.psc_target_service == null ? "projects/cpl-vpop-p-app-global-02/regions/${each.value.region}/serviceAttachments/igc-connector" : each.value.psc_target_service
  project               = var.project_id
  region                = each.value.region
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_backend_service" "imperva_connector_backend" {
  for_each = {
    for bs in local.regional_neg_definitions : "${var.prefix}-bs-${bs.region}" => bs
  }
  name                  = var.region_backend_service_name != null && var.region_backend_service_name != "" ? var.region_backend_service_name : (each.value.suffix_name != null && each.value.suffix_name != "" ? "${var.prefix}-bs-${each.value.region}-${each.value.suffix_name}" : "${var.prefix}-bs-${each.value.region}")
  protocol              = "HTTP2"
  load_balancing_scheme = each.value.load_balancing_scheme
  log_config {
    enable = true
  }
  backend {
    group = google_compute_region_network_endpoint_group.imperva_connector_neg[
      var.network_endpoint_group_name != null && var.network_endpoint_group_name != ""
      ? var.network_endpoint_group_name
      : (
        each.value.suffix_name != null && each.value.suffix_name != ""
        ? "${var.prefix}-neg-${each.value.region}-${each.value.suffix_name}"
        : "${var.prefix}-neg-${each.value.region}"
      )
    ].id

    capacity_scaler = 1
  }
  project = var.project_id
  region  = each.value.region

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_backend_service" "imperva_connector_backend_global" {
  for_each = {
    for bs in distinct(local.global_backend_services) : bs.key => bs.value
  }
  name = (
    var.global_backend_service_name != null && var.global_backend_service_name != ""
    ? var.global_backend_service_name
    : "${var.prefix}-global-bs-${substr(each.key, 0, 5)}${try(each.value.negs[each.key].suffix_name != "" ? "-${each.value.negs[each.key].suffix_name}" : "", "")}"
  )
  protocol              = "HTTP2"
  load_balancing_scheme = each.value.load_balancing_scheme
  log_config {
    enable = true
  }
  dynamic "backend" {
    for_each = each.value.negs
    content {
      group = google_compute_region_network_endpoint_group.imperva_connector_neg[
        (var.network_endpoint_group_name != null && var.network_endpoint_group_name != "") ? var.network_endpoint_group_name :
        "${var.prefix}-neg-${backend.value.region}${backend.value.suffix_name != null && backend.value.suffix_name != "" ? "-${backend.value.suffix_name}" : ""}"
      ].id

      capacity_scaler = 1
    }
  }
  project = var.project_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_network_services_lb_traffic_extension" "imperva_traffic_extension_regional" {
  for_each              = { for r in var.regional_resources : r.load_balancer_name => r }
  name                  = var.network_services_lb_traffic_extension_name != null && var.network_services_lb_traffic_extension_name != "" ? var.network_services_lb_traffic_extension_name : (each.value.suffix_name != null && each.value.suffix_name != "" ? "${substr("${var.prefix}-${each.key}-ste-${each.value.suffix_name}", 0, 59)}" : "${substr("${var.prefix}-${each.key}", 0, 59)}-ste")
  description           = "Imperva For Google Cloud Platform Traffic Extension"
  location              = each.value.region
  load_balancing_scheme = each.value.load_balancing_scheme
  forwarding_rules      = local.regional_forwarding_rule_self_links[each.key]
  project               = var.project_id

  extension_chains {
    name = "default-chain"

    match_condition {
      cel_expression = each.value.cel_expression
    }

    extensions {
      name      = "default-extension"
      authority = each.value.authority_header
      service   = google_compute_region_backend_service.imperva_connector_backend["${var.prefix}-bs-${each.value.region}"].self_link
      timeout   = each.value.timeout
      fail_open = each.value.fail_open

      supported_events = each.value.supported_events

      metadata = merge({
        "lb-id"      = each.key
        "project-id" = var.project_id
      }, each.value.extention_metadata)
    }
  }
  lifecycle {
    ignore_changes = [
      forwarding_rules
    ]
  }
  labels = each.value.labels
}

resource "google_network_services_lb_traffic_extension" "imperva_traffic_extension_global" {
  for_each = { for r in var.global_resources : r.load_balancer_name => r }
  name = (
    var.global_network_services_lb_traffic_extension_name != null && var.global_network_services_lb_traffic_extension_name != ""
    ? var.global_network_services_lb_traffic_extension_name
    : "${substr("${var.prefix}-${each.key}", 0, 59)}-ste${length(each.value.imperva_backends) > 0 && each.value.imperva_backends[0].suffix_name != null && each.value.imperva_backends[0].suffix_name != "" ? "-${each.value.imperva_backends[0].suffix_name}" : ""}"
  )
  description           = "Imperva For Google Cloud Platform Traffic Extension"
  location              = "global"
  load_balancing_scheme = each.value.load_balancing_scheme
  forwarding_rules      = local.global_forwarding_rule_self_links[each.key]
  project               = var.project_id

  extension_chains {
    name = "default-chain"

    match_condition {
      cel_expression = each.value.cel_expression
    }

    extensions {
      name      = "default-extension"
      authority = each.value.authority_header
      service   = google_compute_backend_service.imperva_connector_backend_global[local.global_te_backend_services[each.key]].self_link
      timeout   = each.value.timeout
      fail_open = each.value.fail_open

      supported_events = each.value.supported_events

      metadata = merge({
        "lb-id"      = each.key
        "project-id" = var.project_id
      }, each.value.extention_metadata)
    }
  }

  labels = each.value.labels

  lifecycle {
    ignore_changes = [
      forwarding_rules
    ]
  }
}
