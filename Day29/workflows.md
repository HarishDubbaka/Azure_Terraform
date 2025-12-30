## 🔁 1. Version Control Workflow (VCS-Driven) ✅ *Recommended for Production*

### 📌 What it is

Terraform runs are **automatically triggered by Git events** (push, PR, merge) from a connected repository like **GitHub, GitLab, or Bitbucket**.

You **never run `terraform apply` locally**.

---

### 🔄 How it works

```
Developer → Git Push → GitHub Webhook → HCP Terraform Run → Cloud
```

1. Terraform code lives in Git
2. GitHub webhook notifies HCP Terraform
3. HCP runs:

   * terraform init
   * terraform plan
   * terraform apply (after approval)

---

### 🔐 Key Features

* Remote state (managed by HCP)
* Plan & apply visible in UI
* Manual approval for prod
* Full audit trail
* RBAC & team access
* Sentinel policy support

---

### ✅ Best for

* Production environments
* Teams & enterprises
* Dev / QA / Prod separation
* Compliance & auditing

---

### ⚠️ Important Notes (Very Interview-Relevant)

* Workspace is linked to **repo + branch**
* Variables are **workspace-specific**
* Sensitive variables **cannot be copied**
* Best practice:

  * `dev` branch → dev workspace
  * `main` branch → prod workspace

---

### 🧠 Interview One-Liner

> *Version Control Workflow enables fully automated, auditable Terraform deployments triggered by Git events.*

---

## 💻 2. CLI-Driven Workflow (Terraform CLI)

### 📌 What it is

You run Terraform commands **locally**, but **state is still stored remotely** in HCP Terraform.

---

### 🔄 How it works

```
Developer Laptop → terraform plan/apply → HCP Terraform → Cloud
```

Commands used:

```bash
terraform init
terraform plan
terraform apply
```

---

### 🔐 Key Features

* Remote state & locking
* Local execution
* Faster iteration
* No Git integration required

---

### ✅ Best for

* Learning Terraform
* PoCs and experiments
* Individual developers
* Debugging & testing

---

### ❌ Limitations

* No automatic runs
* No Git audit trail
* Risky for production
* Manual execution errors possible

---

### 🧠 Interview One-Liner

> *CLI-Driven Workflow is suitable for development and testing where engineers directly control Terraform runs.*

---

## 🔌 3. API-Driven Workflow (Advanced / Custom)

### 📌 What it is

Terraform runs are triggered using the **HCP Terraform REST API**.

Typically used by **custom CI/CD pipelines**.

---

### 🔄 How it works

```
CI/CD Tool → HCP Terraform API → Plan → Apply → Cloud
```

Examples:

* Jenkins
* GitHub Actions
* GitLab CI
* Custom internal platforms

---

### 🔐 Key Features

* Full automation
* Custom approval logic
* Integrates with enterprise pipelines
* Programmatic control

---

### ✅ Best for

* Enterprises with custom platforms
* Complex CI/CD pipelines
* Platform engineering teams
* Large-scale automation

---

### ❌ Limitations

* More complex to set up
* Requires API knowledge
* Overkill for beginners

---

### 🧠 Interview One-Liner

> *API-Driven Workflow is used when Terraform must integrate into custom CI/CD or enterprise automation systems.*

---

## 📊 Quick Comparison (Interview Gold)

| Workflow        | Trigger     | State Location | Best For       |
| --------------- | ----------- | -------------- | -------------- |
| Version Control | Git push/PR | Remote (HCP)   | Production     |
| CLI-Driven      | Manual CLI  | Remote (HCP)   | Dev / Learning |
| API-Driven      | REST API    | Remote (HCP)   | Custom CI/CD   |

---

## 🎯 Final Takeaway

* **Use Version Control Workflow for production**
* **Use CLI-Driven for learning & testing**
* **Use API-Driven for advanced automation**

