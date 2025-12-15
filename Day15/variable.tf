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
