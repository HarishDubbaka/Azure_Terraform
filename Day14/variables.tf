variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "dubbaka_harish_rg"

}

variable "allowed_locations" {
  description = "List of allowed locations for resource deployment"
  type        = list(string)
  default     = ["East US", "West Europe", "South India"]
}

variable "nsg_rules" {
  description = "NSG inbound rules"
  type = map(object({
    priority               = number
    destination_port_range = string
    description            = string
  }))
}


variable "password" {
  description = "Password for the VM admin user"
  sensitive   = true
  type        = string
  default     = "P@ssw0rd1234!"
}
