module "component" {
  for_each  = var.component
  source    = "../../module/backend"
  priority  = each.value.priority
  component = each.key
}