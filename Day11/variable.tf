variable "project_name" {
  description = "The name of the resource group"
  type        = string
  default     = "Project ALPHA Resource"
  
}

variable "allowed_locations" {
  description = "List of allowed locations for resource deployment"
  type        = list(string)
  default     = ["East US", "West Europe", "South India"]
}


variable "default_tags" {
  description = "Default tags applied to all resources"
  type        = map(string)
  default     = {
    project     = "terraform"
    owner       = "harish"
  }
}

variable "environment_tags" {
  description = "Environment specific tags"
  type        = map(string)
  default     = {
    environment = "dev"
    team        = "cloud"
  }
}
