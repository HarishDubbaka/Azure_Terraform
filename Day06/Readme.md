# Terraform File and Directory Structure Best Practices

If you’ve been using Terraform for a while, you’ve probably faced this situation:  
a `main.tf` file with 1000+ lines, no clear separation between staging and production, and the creeping fear that any change might break something in another region.  

I’ve been there too.  

This guide walks through how to properly structure your Terraform code to make it **clean, reusable, and scalable** — without pulling your hair out.  
Whether you’re managing three environments or thirty, this will help you sleep better at night.

---

## 🌍 Why Structure Matters
Choosing the proper structure for your Terraform configuration files at the beginning of a project is essential because later restructuring can be challenging and require significant refactoring efforts.  

As your Terraform-managed infrastructure grows, the initial file organization can significantly influence:
- Ease of navigation  
- Speed of updates  
- Team collaboration  

---

## 📂 Foundational Files
When starting a Terraform project, begin with these core files:

- **`providers.tf`** → Defines cloud providers (Azure, AWS, etc.), versions, and authentication.  
- **`versions.tf`** → Specifies required Terraform version and provider constraints.  
- **`backend.tf`** → Defines where Terraform state is stored (Azure Blob Storage, S3, etc.).  
- **`variables.tf`** → Input variable definitions (mostly stable over time).  
- **`outputs.tf`** → Exposes resource attributes for external use.  
- **`main.tf` / `resources.tf` / `modules/*`** → Actual infrastructure resources (frequently updated).  

---

## ⚙️ Terraform File Loading Rules
- Terraform automatically loads all files ending with `.tf` or `.tf.json` inside a directory.  
- Always use the `.tf` extension — otherwise Terraform will ignore your configuration.  

---

## 📌 How Terraform Processes Files
- Terraform **does not execute files in alphabetical order**.  
- Instead, it merges all `.tf` files into a single configuration internally.  
- Resource creation order is determined by **dependencies**, not file names.  

### Dependency Rules
Terraform decides resource order using:
- `depends_on`  
- Resource references (e.g., `resource_a.id`)  
- Module dependencies  

So even if `vnet.tf` comes before `rg.tf` alphabetically, the resource will not be created first unless the dependency tells Terraform to do so.

---

## 🟦 Files That Rarely Change
These are mostly “set-once and forget” files:
1. **providers.tf** → Updated only when adding/upgrading providers.  
2. **versions.tf** → Updated only when upgrading Terraform or provider versions.  
3. **backend.tf** → Updated only when moving state backend or implementing production-ready state management.  
4. **variables.tf** → Core variables remain stable, though new ones may be added gradually.  

---

## 🔧 Files That Change Frequently
- **main.tf / resources.tf / modules/** → Define actual resources; change as infrastructure evolves.  
- **outputs.tf** → Updated when exposing new resource attributes.  

---

## ✅ Key Takeaways
- Keep foundational files (`providers.tf`, `versions.tf`, `backend.tf`) stable.  
- Organize resources into separate `.tf` files or modules for clarity.  
- Remember: **Terraform cares about dependencies, not file names.**  
- A clean structure today saves hours of refactoring tomorrow.  

---

### 📖 Example Directory Layout
```
project-root/
│── backend.tf
│── providers.tf
│── versions.tf
│── variables.tf
│── outputs.tf
│── main.tf
│── modules/
│    ├── networking/
│    ├── compute/
│    └── storage/
│── envs/
     ├── staging/
     └── production/
```

