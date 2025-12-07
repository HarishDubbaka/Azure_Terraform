variable "environment" {
  description = "The environment for the resources"
  type        = string
  default     = "development"
}

variable "storage_os_disk" {
  description = "The size of the OS disk in GB"
  type        = number
  default     = 80
}

variable "delete_os_disk_on_termination" {
  description = "Delete the OS disk when the VM is destroyed"
  type        = bool
  default     = true
}

variable "allowed_locations" {
  description = "List of allowed locations for resource deployment"
  type        = list(string)
  default     = ["East US", "West Europe", "South India"]
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    environment = "staging"
    owner       = "Harish"
    project     = "TerraformDemo"
  }
}
variable "network_config" {
  type    = tuple([string, string, number])
  default = ["10.0.0.0/16", "10.0.2.0/24", 24]
}
#only unique values allowed
variable "allowed_vm_sizes" {
  description = "List of allowed VM sizes"
  type        = list(string)
  default     = ["Standard_B1s", "Standard_DS1_v2", "Standard_F2s_v2"]
  
}

variable "configuration_map" {
  description = "A map containing various configuration settings"
  type        = map(any)
  default = {
    setting1 = "value1"
    setting2 = 42
    setting3 = true
  }
  
}

# Object type
variable "vm_config" {
  type = object({
    size         = string
    publisher    = string
    offer        = string
    sku          = string
    version      = string
  })
  description = "Virtual machine configuration"
  default = {
    size         = "Standard_DS1_v2"
    publisher    = "Canonical"
    offer        = "0001-com-ubuntu-server-jammy"
    sku          = "22_04-lts"
    version      = "latest"
  }
}
