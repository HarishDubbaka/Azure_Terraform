locals {
  transformed_name = replace(lower(var.project_name), " ", "-")
  merged_tags     = merge(var.default_tags, var.environment_tags)
}

resource "azurerm_resource_group" "example" {
  name     = local.transformed_name
  location = var.allowed_locations[1]

  tags = merge..local.merged_tags
}
