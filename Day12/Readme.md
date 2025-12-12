# 🌩️ Terraform Assignments – Functions Deep Dive

A collection of practical Terraform assignments focused on mastering core Terraform functions including **substr, lookup, length, contains, endswith, sensitive, fileexists, dirname, toset, concat, abs, max**, and more.

Each assignment includes scenario, logic, Terraform code, and output examples.

---

## 📘 **Assignment 4 — Storage Account Naming**

**Function Focus:** `substr`, `replace`, `lower`

### **Scenario**

Azure storage account names must be:

* Only lowercase letters & numbers
* Max length: **23 characters**
* No spaces or special characters

### **Solution**

```hcl
variable "storage_account_name" {
  type    = string
  default = "techtutorIALS with!piyushthis should be formatted"
}

locals {
  storage_formatted = replace(
    replace(lower(substr(var.storage_account_name, 0, 23)), " ", ""),
  "!", "")
}
```

### **Output**

```
storage = "techtutorialswithpiyu"
```

---

## 📘 **Assignment 5 — Environment Lookup**

**Function Focus:** `lookup`

### **Scenario**

Return environment-specific config, and fallback to defaults for invalid environment names.

### **Input**

```hcl
variable "environments" {
  type = map(object({
    instance_size = string
    redundancy    = string
  }))

  default = {
    dev = {
      instance_size = "small"
      redundancy    = "low"
    }
    prod = {
      instance_size = "large"
      redundancy    = "high"
    }
  }
}

variable "selected_env" {
  type    = string
  default = "prod"
}
```

### **Logic**

```hcl
locals {
  env_config = lookup(
    var.environments,
    var.selected_env,
    { instance_size = "large", redundancy = "high" }
  )
}
```

### **Output**

```
env_config = {
  instance_size = "large"
  redundancy    = "high"
}
```

---

## 📘 **Assignment 6 — VM Size Validation**

**Functions Focus:** `length`, `contains`, `strcontains`

### **Rules**

* Must contain the word `"standard"`
* Length must be between **2 and 20** chars

### **Code**

```hcl
variable "vm_size" {
  type    = string
  default = "standard_D2s_v3"

  validation {
    condition     = length(var.vm_size) >= 2 && length(var.vm_size) <= 20
    error_message = "VM size must be between 2 and 20 characters."
  }

  validation {
    condition     = strcontains(lower(var.vm_size), "standard")
    error_message = "VM size must contain the word 'standard'."
  }
}
```

### **Example Error**

```
Error: The vm size should contain standard
```

---

## 📘 **Assignment 7 — Backup Configuration**

**Functions Focus:** `endswith`, `sensitive`

### **Rules**

* Backup name must end with `_backup`
* Credential must be stored securely

### **Code**

```hcl
variable "backup_name" {
  default = "daily_backup"
  validation {
    condition     = endswith(var.backup_name, "_backup")
    error_message = "Backup name must end with _backup"
  }
}

variable "credential" {
  default   = "xyz123"
  sensitive = true
}

output "credential" {
  value     = var.credential
  sensitive = true
}
```

### **Output**

```
credential = <sensitive>
```

---

## 📘 **Assignment 8 — File Path Processing**

**Functions Focus:** `fileexists`, `dirname`

### **Scenario**

Check whether files exist.

### **Code**

```hcl
variable "paths_to_validate" {
  type = list(string)
  default = [
    "./main.tf",
    "./variables.tf"
  ]
}

locals {
  file_exists = [for p in var.paths_to_validate : fileexists(p)]
}

output "file_exists" {
  value = local.file_exists
}
```

### **Output**

```
file_exists = [ true, false ]
```

---

## 📘 **Assignment 9 — Unique Location Set**

**Functions Focus:** `toset`, `concat`

### **Scenario**

Remove duplicates from user + default locations.

### **Code**

```hcl
locals {
  user_location    = ["eastus", "westus", "eastus"]
  default_location = ["centralus"]

  unique_locations = toset(concat(local.user_location, local.default_location))
}
```

### **Output**

```
unique_locations = toset(["centralus", "eastus", "westus"])
```

---

## 📘 **Assignment 10 — Cost Calculation**

**Functions Focus:** `abs`, `max`

### **Scenario**

Convert negative cost values to positive and find the max cost.

### **Code**

```hcl
locals {
  monthly_costs = [-50, 100, 75, 200]

  positive_cost = [for c in local.monthly_costs : abs(c)]
  max_cost      = max(local.positive_cost...)
}

output "max_cost" {
  value = local.max_cost
}
```

### **Output**

```
max_cost = 200
```

---

# 🎯 Summary of Functions Used

| Category    | Functions                        |
| ----------- | -------------------------------- |
| String      | lower, replace, substr, endswith |
| Numeric     | abs, max                         |
| Validation  | contains, strcontains, length    |
| Collections | lookup, concat, toset            |
| File Ops    | fileexists                       |
| Sensitive   | sensitive                        |

---


