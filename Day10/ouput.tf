output "rgname" {
  value = azurerm_resource_group.example[*].name
}

output "environment" {
  value = var.environment
  
}

output "splatted_rgname" {
  #value = [ for count in local.nsg_rules : count.description ]
  value = local.nsg_rules[*]
}
