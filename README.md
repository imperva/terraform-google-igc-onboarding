# Imperva For Google Cloud Platform Terraform Module

Provisions Imperva For Google Cloud Platform resources for a given Application Load Balancer.

## Requirements

- Terraform 0.13+
- Google Cloud Platform account and project ID.
- Service account with the necessary permissions
- Pre-existing Forwarding Rules and VPC/Subnet setup.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.45 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 6.45 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_backend_service.imperva_connector_backend_global](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service) | resource |
| [google_compute_region_backend_service.imperva_connector_backend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service) | resource |
| [google_compute_region_network_endpoint_group.imperva_connector_neg](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_network_endpoint_group) | resource |
| [google_network_services_lb_traffic_extension.imperva_traffic_extension_global](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_services_lb_traffic_extension) | resource |
| [google_network_services_lb_traffic_extension.imperva_traffic_extension_regional](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_services_lb_traffic_extension) | resource |
| [google_compute_forwarding_rule.forwarding_rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_forwarding_rule) | data source |
| [google_compute_global_forwarding_rule.forwarding_rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_global_forwarding_rule) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_global_backend_service_name"></a> [global\_backend\_service\_name](#input\_global\_backend\_service\_name) | Custom name for the global Backend Service. If not set, the name is generated automatically based on prefix, key, and optional suffix. | `string` | `null` | no |
| <a name="input_global_network_services_lb_traffic_extension_name"></a> [global\_network\_services\_lb\_traffic\_extension\_name](#input\_global\_network\_services\_lb\_traffic\_extension\_name) | Custom name for the global Network Services LB Traffic Extension. If not set, the name is generated automatically and truncated to meet GCP length requirements. | `string` | `null` | no |
| <a name="input_global_resources"></a> [global\_resources](#input\_global\_resources) | List of regional traffic extensions | <pre>list(object({<br/>    load_balancing_scheme = optional(string, "EXTERNAL_MANAGED")<br/>    authority_header      = string<br/>    forwarding_rules      = list(string)<br/>    load_balancer_name    = string<br/>    cel_expression        = optional(string, "true")<br/>    timeout               = optional(string, "1.0s")<br/>    fail_open             = optional(bool, false)<br/>    imperva_backends = list(object({<br/>      region             = string<br/>      network            = string<br/>      subnet             = string<br/>      psc_target_service = optional(string)<br/>      suffix_name        = optional(string)<br/>    }))<br/>    supported_events = optional(list(string), [<br/>      "REQUEST_HEADERS",<br/>      "REQUEST_BODY",<br/>      "REQUEST_TRAILERS",<br/>      "RESPONSE_HEADERS",<br/>      "RESPONSE_BODY",<br/>      "RESPONSE_TRAILERS"<br/>    ])<br/>    labels = optional(map(string), {<br/>      created_by = "terraform"<br/>    })<br/>    extention_metadata = optional(map(string), {})<br/>  }))</pre> | `[]` | no |
| <a name="input_network_endpoint_group_name"></a> [network\_endpoint\_group\_name](#input\_network\_endpoint\_group\_name) | Custom name for the regional Network Endpoint Group (NEG). If not set, the name is generated automatically based on prefix, region, and optional suffix. | `string` | `null` | no |
| <a name="input_network_services_lb_traffic_extension_name"></a> [network\_services\_lb\_traffic\_extension\_name](#input\_network\_services\_lb\_traffic\_extension\_name) | Custom name for the regional Network Services LB Traffic Extension. If not set, the name is generated automatically and truncated to meet GCP length requirements. | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Default prefix for all resources. | `string` | `"imperva"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | project id to create resources in | `any` | n/a | yes |
| <a name="input_region_backend_service_name"></a> [region\_backend\_service\_name](#input\_region\_backend\_service\_name) | Custom name for the regional Backend Service. If not set, the name is generated automatically based on prefix, region, and optional suffix. | `string` | `null` | no |
| <a name="input_regional_resources"></a> [regional\_resources](#input\_regional\_resources) | List of regional traffic extensions | <pre>list(object({<br/>    region                = string<br/>    network               = string<br/>    subnet                = string<br/>    psc_target_service    = optional(string)<br/>    load_balancing_scheme = optional(string, "EXTERNAL_MANAGED")<br/>    authority_header      = string<br/>    forwarding_rules      = list(string)<br/>    load_balancer_name    = string<br/>    cel_expression        = optional(string, "true")<br/>    timeout               = optional(string, "1.0s")<br/>    fail_open             = optional(bool, false)<br/>    suffix_name           = optional(string)<br/>    supported_events = optional(list(string), [<br/>      "REQUEST_HEADERS",<br/>      "REQUEST_BODY",<br/>      "REQUEST_TRAILERS",<br/>      "RESPONSE_HEADERS",<br/>      "RESPONSE_BODY",<br/>      "RESPONSE_TRAILERS"<br/>    ])<br/>    labels = optional(map(string), {<br/>      created_by = "terraform"<br/>    })<br/>    extention_metadata = optional(map(string), {})<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_imperva_global_backend_services"></a> [imperva\_global\_backend\_services](#output\_imperva\_global\_backend\_services) | Imperva For Google Cloud Platform Regional Backend Services |
| <a name="output_imperva_network_endpoint_groups"></a> [imperva\_network\_endpoint\_groups](#output\_imperva\_network\_endpoint\_groups) | Imperva For Google Cloud Platform Network Endpoint Groups |
| <a name="output_imperva_regional_backend_services"></a> [imperva\_regional\_backend\_services](#output\_imperva\_regional\_backend\_services) | Imperva For Google Cloud Platform Regional Backend Services |
| <a name="output_protected_forwarding_rules"></a> [protected\_forwarding\_rules](#output\_protected\_forwarding\_rules) | Forwarding rules protected by Imperva For Google Cloud Platform |
<!-- END_TF_DOCS -->

## Parameters - Explained

| Key                        | Type            | Description                                                                                                                                                                                                                 |
|----------------------------|-----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| load_balancer_name         | string          | Name of the Traffic Extension.                                                                                                                                                                                              |
| traffic_extension_description | string      | Optional description for the Traffic Extension.                                                                                                                                                                             |
| cel_expression             | string          | CEL expression to match requests. [CEL Reference](https://cloud.google.com/service-extensions/docs/cel-matcher-language-reference)                                                                                           |
| timeout                    | string          | Timeout duration (e.g., 1.0s).                                                                                                                                                                                              |
| fail_open                  | bool            | Whether to allow requests to continue if the extension call fails.                                                                                                                                                          |
| supported_events           | list(string)    | Events the extension should process. Valid values: `REQUEST_HEADERS`, `REQUEST_BODY`, `RESPONSE_HEADERS`, `RESPONSE_BODY`, `REQUEST_TRAILERS`, `RESPONSE_TRAILERS`.                                                         |
| labels                     | map(string)     | Key-value labels to apply to created resources.                                                                                                                                                                             |
| region                     | string          | Region of the Load Balancer and extension resources.                                                                                                                                                                        |
| network                    | string          | VPC network of the Load Balancer.                                                                                                                                                                                           |
| subnet                     | string          | Subnet used by the Load Balancer and extension resources.                                                                                                                                                                   |
| psc_target_service         | string          | Fully qualified name of the Private Service Connect attachment target (provided by Imperva).                                                                                                                                |
| load_balancing_scheme      | string          | Load balancing scheme: EXTERNAL_MANAGED, INTERNAL_MANAGED.                                                                                                                                                                  |
| authority_header           | string          | The authority header used for the extension. Provided by Imperva.                                                                                                                                                           |
| forwarding_rules           | list(string)    | Names of the forwarding rules to attach this extension to.                                                                                                                                                                  |
| prefix                    | string          | Default prefix for all resources.                                                                                                                                                                                            |
For global resources `region`, `network`, `subnet` and `psc_target_service` are provided via `imperva_backends` map, so multiple regions can be attached to the global resource.

## Traffic Extension Metadata (`extention_metadata`)

The `extention_metadata` field allows you to pass custom key-value pairs as metadata to the traffic extension. This metadata is merged with system-defined values (`lb-id` and `project-id`) and sent via HTTP2 to the Imperva extension processor.

**Example usage:**

```hcl
regional_resources = [
  {
    load_balancer_name    = "unique-load-balancer-name"
    region                = "us-west2"
    network               = "vpc-network"
    subnet                = "subnet"
    authority_header      = "imperva-authority-header.cplcloud.com"
    forwarding_rules      = ["your-regional-forwarding-rule"]
    extention_metadata    = {
      custom_key1 = "custom_value1"
      custom_key2 = "custom_value2"
    }
  }
]
```

If not specified, `extention_metadata` defaults to an empty map.

## Usage - Example

```hcl
module "imperva_for_google_cloud_platform" {
  source = "./imperva-for-google-cloud-platform"

  project_id = "your-gcp-project-id"

  regional_resources = [
    {
      load_balancer_name    = "unique-load-balancer-name"
      region                = "us-west2"
      network               = "vpc-network"
      subnet                = "subnet"
      authority_header      = "imperva-authority-header.cplcloud.com"
      forwarding_rules      = ["your-regional-forwarding-rule"]
    }
  ]

  global_resources = [
    {
      load_balancer_name     = "unique-global-load-balancer-name"
      authority_header       = "imperva-authority-header.cplcloud.com"
      forwarding_rules       = ["your-global-forwarding-rule1"]
      imperva_backends       = [
        {
          region             = "us-west2"
          network            = "vpc-network"
          subnet             = "subnet-uwe2"
        },
        {
          region             = "us-east1"
          network            = "vpc-network"
          subnet             = "subnet-uea1"
        }
      ]
    }
  ]
```
