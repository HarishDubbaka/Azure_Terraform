terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.1.0"
    }
  }
}

provider "azuread" {
  tenant_id = var.tenant_id
}

# Load CSV
locals {
  users = csvdecode(file(var.users_csv_path))

  departments = distinct([for u in local.users : u.department])
  roles       = distinct([for u in local.users : u.role])
}

# ---------------------------------------------------------
# Create Azure AD Users
# ---------------------------------------------------------
resource "azuread_user" "users" {
  for_each = {
    for u in local.users :
    replace(lower(u.name), " ", "_") => u
  }

  display_name        = each.value.name
  user_principal_name = "${replace(lower(each.value.name), " ", ".")}@${var.domain_name}"
  mail_nickname       = replace(lower(each.value.name), " ", ".")
  department          = each.value.department
  job_title           = each.value.role

  password              = var.default_password
  force_password_change = true
}

# ---------------------------------------------------------
# Create Groups by Department
# ---------------------------------------------------------
resource "azuread_group" "department_groups" {
  for_each = toset(local.departments)

  display_name     = "${each.key} Department"
  security_enabled = true
}

# ---------------------------------------------------------
# Create Groups by Role
# ---------------------------------------------------------
resource "azuread_group" "role_groups" {
  for_each = toset(local.roles)

  display_name     = "${each.key} Role"
  security_enabled = true
}

resource "azuread_group_member" "department_members" {
  for_each = {
    for u in local.users :
    "${replace(lower(u.name), " ", "_")}_dept" => u
  }

  group_object_id  = azuread_group.department_groups[each.value.department].object_id
  member_object_id = azuread_user.users[replace(lower(each.value.name), " ", "_")].object_id
}

resource "azuread_group_member" "role_members" {
  for_each = {
    for u in local.users :
    "${replace(lower(u.name), " ", "_")}_role" => u
  }

  group_object_id  = azuread_group.role_groups[each.value.role].object_id
  member_object_id = azuread_user.users[replace(lower(each.value.name), " ", "_")].object_id
}
