# ☁️ HashiCorp Cloud Platform (HCP) & HCP Terraform – Complete Guide

## 📌 Overview

**HashiCorp Cloud Platform (HCP)** is HashiCorp’s **fully managed cloud offering** that provides enterprise-grade infrastructure tools without the operational overhead of managing backend services yourself.

HCP enables teams to securely provision, manage, and govern infrastructure at scale.

---

## 🚀 Core HCP Services

### 🔹 HCP Terraform (Terraform Cloud)

* Remote state management
* Secure variables & secrets
* Team collaboration & RBAC
* Remote plan & apply
* Audit logs & run history
* Policy as Code (Sentinel)

### 🔹 HCP Vault

* Fully managed secrets management
* Dynamic credentials
* Encryption as a service
* No Vault cluster maintenance

### 🔹 HCP Consul

* Service discovery
* Service mesh
* Health checks
* Networking automation

---

## 🔐 Why Use HCP Cloud?

✔ No backend infrastructure to manage
✔ Built-in security & encryption
✔ Automatic scaling
✔ Centralized governance
✔ Production-ready by default

---

## 🛠️ HCP vs Open Source Terraform

| Feature       | Open Source Terraform | HCP Terraform    |
| ------------- | --------------------- | ---------------- |
| State Storage | Local / DIY backend   | Fully managed    |
| Collaboration | Manual                | Built-in         |
| Security      | Self-managed          | Enterprise-grade |
| Scaling       | User responsibility   | Automatic        |
| Audit Logs    | Limited               | Built-in         |

---

## 🎯 Best Use Cases

* Enterprise Terraform workflows
* Multi-team DevOps environments
* Secure secrets & credentials
* Compliance & governance enforcement

---

## 💡 Key Takeaway

> **HCP lets you focus on building infrastructure, not managing tooling.**

---

# 🔁 HCP Terraform Workflow (Step-by-Step)

## 🧠 High-Level Architecture

```
Developer → Git Repository → HCP Terraform → Cloud Provider
```

HCP Terraform acts as the **central control plane** for infrastructure delivery.

---

## 1️⃣ Create an Organization

* Sign in to **[https://app.terraform.io](https://app.terraform.io)**
* Create an **Organization**
* This contains:

  * Workspaces
  * Teams
  * Policies

---

## 2️⃣ Create a Workspace

A **Workspace** represents:

* One environment (`dev`, `qa`, `prod`)
* OR one application

### Workspace Types

* **Version Control (VCS) Workflow** ✅ Recommended
* CLI-driven workflow

---

## 3️⃣ Connect Version Control (GitHub)

* Install the **Terraform GitHub App**
* Select repository & branch
* Terraform code is pulled directly from GitHub

📌 Any `git push` automatically triggers a run.

---

## 4️⃣ Configure Variables (Critical Step)

### Terraform Variables

* Configuration values (location, size, tags)
* Workspace-specific

### Environment Variables

* Used for secrets & credentials
* Stored **encrypted**

Example (Azure):

```text
ARM_CLIENT_ID
ARM_CLIENT_SECRET
ARM_SUBSCRIPTION_ID
ARM_TENANT_ID
```

⚠️ **Important Notes**

* Variables are **workspace-specific**
* HCP Terraform **does not allow copying variables** across workspaces
* Sensitive variables are masked and encrypted

---

## 5️⃣ Write Terraform Code

Example:

```hcl
provider "azurerm" {
  features {}
}
```

✅ No backend block required
HCP Terraform automatically manages:

* Remote state
* Locking
* Versioning

---

## 6️⃣ Commit & Push Code

```bash
git add .
git commit -m "Add infrastructure"
git push origin main
```

➡️ Triggers **remote terraform plan** in HCP Terraform

---

## 7️⃣ Terraform Plan (Remote)

HCP Terraform:

* Downloads providers
* Reads remote state
* Generates execution plan
* Displays output in UI

You review:

* Resources to create
* Modify
* Destroy

---

## 8️⃣ Review & Approval

Depending on settings:

* Auto-apply (dev)
* Manual approval (recommended for prod)

✔ Approved → Apply
❌ Rejected → No changes

---

## 9️⃣ Terraform Apply (Remote)

Once approved:

* HCP runs `terraform apply`
* Updates cloud infrastructure
* Updates remote state securely

---

## 🔐 10️⃣ State Management (Behind the Scenes)

HCP Terraform automatically provides:

* Encrypted remote state
* State locking
* Drift detection
* State history

🚫 No local `.tfstate` files

---

## 🛡️ 11️⃣ Governance & Policies (Optional)

Using **Sentinel Policies**:

* Enforce tagging standards
* Restrict regions
* Limit VM sizes

Example policy:

> Deny resources without mandatory `env` tag

---

## 🔁 12️⃣ Day-2 Operations

* Drift detection
* Re-runs
* Rollbacks
* Audit logs
* Notifications

---

# 🧩 Workspace & Environment Strategy (Interview Focus)

## 🏗️ Workspace Separation

Use separate workspaces:

* `dev`
* `qa`
* `prod`

Each workspace has:

* Its own **state**
* Its own **variables**
* Its own **permissions**

---

## 🌿 Branch-to-Workspace Mapping (Best Practice)

| Git Branch      | HCP Workspace |
| --------------- | ------------- |
| `dev`           | dev           |
| `qa`            | qa            |
| `main` / `prod` | prod          |

✔ Prevents accidental production changes
✔ Enables safe CI/CD workflows

---

## 🧠 Interview Takeaways

* HCP Terraform securely manages remote state
* Workspaces isolate environments completely
* GitHub webhooks enable automation
* Variables are encrypted and workspace-scoped
* Branch-based workflows ensure safe deployments

---

## ⭐ One-Line Interview Summary

> **HCP Terraform integrates Git-based workflows with secure remote state, workspace isolation, and automated infrastructure delivery at enterprise scale.**

---
