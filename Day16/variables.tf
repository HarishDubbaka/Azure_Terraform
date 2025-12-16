variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
}

variable "domain_name" {
  description = "Domain for user_principal_name"
  type        = string
}

variable "default_password" {
  description = "Temporary password for new users"
  type        = string
  sensitive   = true
}

variable "users_csv_path" {
  description = "Path to users.csv"
  type        = string
  default     = "users.csv"
}

