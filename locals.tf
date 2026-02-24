locals {
  # Regional NEGs
  regional_neg_definitions = distinct(flatten([
    for r in var.regional_resources : {
      key                   = sha1(join("|", [r.region, r.network, r.subnet]))
      region                = r.region
      network               = r.network
      subnet                = r.subnet
      psc_target_service    = r.psc_target_service
      load_balancing_scheme = r.load_balancing_scheme
      suffix_name           = r.suffix_name
    }
  ]))

  # Global NEGs
  global_neg_definitions = distinct(flatten([
    for g in var.global_resources : [
      for res in g.imperva_backends : {
        key                   = sha1(join("|", [res.region, res.network, res.subnet]))
        region                = res.region
        network               = res.network
        subnet                = res.subnet
        psc_target_service    = res.psc_target_service
        load_balancing_scheme = g.load_balancing_scheme
        suffix_name           = try(res.suffix_name, "")
      }
    ]
  ]))

  # All NEGs
  all_neg_definitions = distinct(concat(local.regional_neg_definitions, local.global_neg_definitions))
}

# Unique backend services. Generated from region|network|subnet combinations, to prevent creating multiple backends with the same NEGs set
locals {
  global_te_backend_services = {
    for r in var.global_resources :
    r.load_balancer_name => sha1(join(",", sort([
      for ter in r.imperva_backends :
      "${ter.region}|${ter.network}|${ter.subnet}"
    ])))
  }

  global_backend_services = [
    for gr in var.global_resources : {
      key = sha1(join(",", sort([
        for ter in gr.imperva_backends :
        "${ter.region}|${ter.network}|${ter.subnet}"
      ])))
      value = {
        load_balancing_scheme = gr.load_balancing_scheme
        negs = {
          for ter in gr.imperva_backends :
          sha1("${ter.region}|${ter.network}|${ter.subnet}") => {
            region             = ter.region
            network            = ter.network
            subnet             = ter.subnet
            psc_target_service = ter.psc_target_service
            suffix_name        = try(ter.suffix_name, "")
          }
        }
      }
    }
  ]
}

locals {
  regional_forwarding_rules = flatten([
    for res in var.regional_resources : [
      for rule in res.forwarding_rules : {
        rule   = rule
        region = res.region
      }
    ]
  ])

  regional_forwarding_rule_self_links = {
    for res in var.regional_resources : res.load_balancer_name => [
      for rule in res.forwarding_rules : data.google_compute_forwarding_rule.forwarding_rule[rule].self_link
    ]
  }

  global_forwarding_rules = flatten([
    for res in var.global_resources : [
      for rule in res.forwarding_rules : rule
    ]
  ])

  global_forwarding_rule_self_links = {
    for res in var.global_resources : res.load_balancer_name => [
      for rule in res.forwarding_rules : data.google_compute_global_forwarding_rule.forwarding_rule[rule].self_link
    ]
  }
}