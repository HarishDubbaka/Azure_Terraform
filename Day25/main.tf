data "azurerm_subscription" "current" {}

########################################
# 1️⃣ TAG GOVERNANCE POLICY
########################################
resource "azurerm_policy_definition" "tag" {
  name         = "required-tags-policy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Required Tags Policy"

  policy_rule = jsonencode({
    if = {
      anyOf = [
        {
          field  = "tags.${var.allowed_tags[0]}"
          exists = false
        },
        {
          field  = "tags.${var.allowed_tags[1]}"
          exists = false
        }
      ]
    }
    then = {
      effect = "Deny"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "tag_assignment" {
  name                 = "required-tags-assignment"
  policy_definition_id = azurerm_policy_definition.tag.id
  subscription_id      = data.azurerm_subscription.current.id
}

########################################
# 2️⃣ VM SIZE GOVERNANCE POLICY
########################################
resource "azurerm_policy_definition" "vm_size" {
  name         = "allowed-vm-sizes-policy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed VM Sizes Policy"

  policy_rule = jsonencode({
    if = {
      not = {
        field = "Microsoft.Compute/virtualMachines/sku.name"
        in    = var.vm_sizes
      }
    }
    then = {
      effect = "Deny"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "vm_size_assignment" {
  name                 = "vm-size-assignment"
  policy_definition_id = azurerm_policy_definition.vm_size.id
  subscription_id      = data.azurerm_subscription.current.id
}

########################################
# 3️⃣ LOCATION GOVERNANCE POLICY
########################################
resource "azurerm_policy_definition" "location" {
  name         = "allowed-locations-policy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed Locations Policy"

  policy_rule = jsonencode({
    if = {
      not = {
        field = "location"
        in    = var.location
      }
    }
    then = {
      effect = "Deny"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "location_assignment" {
  name                 = "location-assignment"
  policy_definition_id = azurerm_policy_definition.location.id
  subscription_id      = data.azurerm_subscription.current.id
}
