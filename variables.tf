variable "project_id" {
  description = "project id to create resources in"
}

variable "prefix" {
  default     = "imperva"
  type        = string
  description = "Default prefix for all resources."
}

variable "regional_resources" {
  description = "List of regional traffic extensions"
  type = list(object({
    region                = string
    network               = string
    subnet                = string
    psc_target_service    = optional(string)
    load_balancing_scheme = optional(string, "EXTERNAL_MANAGED")
    authority_header      = string
    forwarding_rules      = list(string)
    load_balancer_name    = string
    cel_expression        = optional(string, "true")
    timeout               = optional(string, "1.0s")
    fail_open             = optional(bool, false)
    suffix_name           = optional(string)
    supported_events = optional(list(string), [
      "REQUEST_HEADERS",
      "REQUEST_BODY",
      "REQUEST_TRAILERS",
      "RESPONSE_HEADERS",
      "RESPONSE_BODY",
      "RESPONSE_TRAILERS"
    ])
    labels = optional(map(string), {
      created_by = "terraform"
    })
    extention_metadata = optional(map(string), {})
  }))
  default = []

  validation {
    condition     = length(var.regional_resources) == length(distinct([for r in var.regional_resources : r.load_balancer_name]))
    error_message = "Each 'load_balancer_name' must be unique."
  }

  validation {
    condition     = length(flatten([for r in var.regional_resources : r.forwarding_rules])) == length(distinct(flatten([for r in var.regional_resources : r.forwarding_rules])))
    error_message = "Each forwarding rule must be unique across all regional resources."
  }
}

variable "global_resources" {
  description = "List of regional traffic extensions"
  type = list(object({
    load_balancing_scheme = optional(string, "EXTERNAL_MANAGED")
    authority_header      = string
    forwarding_rules      = list(string)
    load_balancer_name    = string
    cel_expression        = optional(string, "true")
    timeout               = optional(string, "1.0s")
    fail_open             = optional(bool, false)
    imperva_backends = list(object({
      region             = string
      network            = string
      subnet             = string
      psc_target_service = optional(string)
      suffix_name        = optional(string)
    }))
    supported_events = optional(list(string), [
      "REQUEST_HEADERS",
      "REQUEST_BODY",
      "REQUEST_TRAILERS",
      "RESPONSE_HEADERS",
      "RESPONSE_BODY",
      "RESPONSE_TRAILERS"
    ])
    labels = optional(map(string), {
      created_by = "terraform"
    })
    extention_metadata = optional(map(string), {})
  }))
  default = []

  validation {
    condition     = length(var.global_resources) == length(distinct([for r in var.global_resources : r.load_balancer_name]))
    error_message = "Each 'load_balancer_name' must be unique."
  }

  validation {
    condition     = length(flatten([for r in var.global_resources : r.forwarding_rules])) == length(distinct(flatten([for r in var.global_resources : r.forwarding_rules])))
    error_message = "Each forwarding rule must be unique across all global resources."
  }
}

variable "network_endpoint_group_name" {
  type        = string
  default     = null
  description = "Custom name for the regional Network Endpoint Group (NEG). If not set, the name is generated automatically based on prefix, region, and optional suffix."
}

variable "region_backend_service_name" {
  type        = string
  default     = null
  description = "Custom name for the regional Backend Service. If not set, the name is generated automatically based on prefix, region, and optional suffix."
}

variable "global_backend_service_name" {
  type        = string
  default     = null
  description = "Custom name for the global Backend Service. If not set, the name is generated automatically based on prefix, key, and optional suffix."
}

variable "network_services_lb_traffic_extension_name" {
  type        = string
  default     = null
  description = "Custom name for the regional Network Services LB Traffic Extension. If not set, the name is generated automatically and truncated to meet GCP length requirements."
}

variable "global_network_services_lb_traffic_extension_name" {
  type        = string
  default     = null
  description = "Custom name for the global Network Services LB Traffic Extension. If not set, the name is generated automatically and truncated to meet GCP length requirements."
}
