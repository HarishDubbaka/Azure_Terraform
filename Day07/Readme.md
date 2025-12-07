Terraform Type Constraints Guide

This document explains the fundamental and complex type constraints in Terraform, along with commonly used commands.

🔹 Fundamental Types: Your Building Blocks

String Type

variable "environment" {
  description = "The environment for the resources"
  type        = string
  default     = "development"
}

Represents text values wrapped in quotes.

Most commonly used type.

Number Type

variable "storage_os_disk" {
  description = "The name of the storage disk size in GB"
  type        = number
  default     = 80
}

Can be integers or decimals.

Terraform automatically determines the number type.

Bool Type

variable "delete_os_disk_on_termination" {
  description = "Enable or disable delete_os_disk_on_termination"
  type        = bool
  default     = true
}

Represents true/false values.

Useful for enabling or disabling features.

🔹 Complex Types: When Simple Isn’t Enough

List Type

variable "availability_zones" {
  type        = list(string)
  description = "List of AZs to deploy into"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

Ordered collection of elements.

All elements must be of the same type.

Map Type

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {
    environment = "staging"
    owner       = "Harish"
    project     = "TerraformDemo"
  }
}

Key-value pairs.

Useful for metadata and tagging.

Tuple Type

variable "network_config" {
  description = "Type of network configuration"
  type        = tuple([string, string, number])
  default     = ["10.0.0.0/16", "10.0.2.0/24", 24]
}

Ordered collection with fixed structure.

Each position can have a different type.

Set Type

variable "security_groups" {
  type        = set(string)
  description = "Set of security group IDs"
  default     = ["sg-123", "sg-456", "sg-789"]
}

Unordered collection of unique values.

Prevents duplicates.

Object Type

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

Complex structure with multiple attributes.

Each attribute can have its own type.

⚙️ Common Terraform Commands

terraform fmt → Formats Terraform configuration files to canonical style.

terraform validate → Validates syntax and configuration.

terraform plan → Creates an execution plan, showing what actions Terraform will take.

✅ Summary

Terraform type constraints help ensure that variables are used consistently and correctly. By combining fundamental and complex types, you can model real-world infrastructure with precision. Always use terraform fmt, terraform validate, and terraform plan to maintain clean, error-free configurations.
