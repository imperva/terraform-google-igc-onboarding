data "google_compute_forwarding_rule" "forwarding_rule" {
  for_each = { for r in local.regional_forwarding_rules : r.rule => r }

  name    = each.value.rule
  project = var.project_id
  region  = each.value.region
}

data "google_compute_global_forwarding_rule" "forwarding_rule" {
  for_each = { for r in local.global_forwarding_rules : r => r }
  name     = each.value
  project  = var.project_id
}
