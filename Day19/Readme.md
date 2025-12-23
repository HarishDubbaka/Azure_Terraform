# Terraform Essentials & Cheat Sheet

## 📌 Daily Focus
Today I focused on essential Terraform commands that are used daily while working with Infrastructure as Code (IaC).  
Mastering these commands helps in planning, deploying, and managing cloud infrastructure efficiently.

---

## 🚀 Core Commands

| Command              | Purpose                                                                 | Example                          |
|----------------------|-------------------------------------------------------------------------|----------------------------------|
| `terraform init`     | Initializes a new/existing project, downloads providers, sets up backend | `terraform init`                 |
| `terraform plan`     | Shows what changes Terraform will make without applying them             | `terraform plan -out=tfplan`     |
| `terraform apply`    | Applies the planned changes to provision/update infrastructure           | `terraform apply tfplan`         |
| `terraform destroy`  | Tears down all resources defined in configuration                        | `terraform destroy`              |
| `terraform validate` | Checks syntax and internal consistency of `.tf` files                    | `terraform validate`             |
| `terraform fmt`      | Formats `.tf` files to canonical style                                   | `terraform fmt -recursive`       |
| `terraform show`     | Displays current state or plan in human-readable form                    | `terraform show`                 |
| `terraform output`   | Prints values defined as outputs in configuration                        | `terraform output storage_name`  |
| `terraform state`    | Inspect or modify Terraform’s state file                                 | `terraform state list`           |
| `terraform workspace`| Manage multiple workspaces (dev/test/prod separation)                    | `terraform workspace new dev`    |

---

## ⚡ Pro Tips
- Always run `terraform plan` before `apply` to avoid surprises.  
- Use **workspaces** for environment separation (dev/test/prod).  
- Keep your **state file secure** (remote backends like Azure Storage or S3).  
- Use **modules** for reusable infrastructure patterns.  
- Run `terraform fmt` and `terraform validate` before committing code.  

---

## 📖 Why These Matter
These commands form the backbone of daily Terraform workflows. By mastering them, you can:
- Plan infrastructure changes safely before applying.  
- Deploy cloud resources consistently.  
- Manage lifecycle operations like updates and teardown.  
- Keep configurations clean, validated, and well-documented.  

---

