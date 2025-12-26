variable "allowed_tags" {
  type        = list(string)
  description = "Mandatory tags for all resources"
}

variable "vm_sizes" {
  type        = list(string)
  description = "Allowed VM sizes"
}

variable "location" {
  type        = list(string)
  description = "Allowed Azure locations"
}
