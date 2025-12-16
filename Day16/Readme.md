# Azure AD User & Group Automation using Terraform

---

## Overview

This project demonstrates a **production-ready Terraform configuration** that automates **Azure Active Directory (Entra ID)** identity management.

The solution reads user data from a CSV file, dynamically creates users, creates security groups based on department and role, and assigns users to the appropriate groups — all using **Infrastructure as Code (IaC)**.

---

## Key Features

* CSV-driven user onboarding
* Automated Azure AD user creation
* Dynamic group creation

  * Department-based groups
  * Role-based groups
* Automatic group membership assignment
* Scalable and repeatable Terraform design
* No hardcoded users or groups

---

## Folder Structure

```
project/
├── main.tf
├── variables.tf
├── terraform.tfvars
├── users.csv
```

---

## Input File: users.csv

```
name,department,role
Michael Scott,Education,Manager
Jim Halpert,Education,Engineer
Pam Beesly,Education,Engineer
```

Each row in the CSV represents:

* One Azure AD user
* Assigned department
* Assigned role

This makes the solution **data-driven**, allowing easy onboarding by updating the CSV file.

---

## How It Works

### Step 1: CSV Processing

Terraform reads and parses the CSV file using `csvdecode()`.

* User objects are generated dynamically
* Unique departments are extracted
* Unique roles are extracted

---

### Step 2: User Creation

For each CSV entry:

* An Azure AD user is created
* User Principal Name (UPN) is generated automatically
* Department and role are assigned
* Password reset is enforced at first login

---

### Step 3: Group Creation

Terraform creates security groups dynamically:

#### Department Groups

* One group per unique department
  Example:
  *Education Department*

#### Role Groups

* One group per unique role
  Example:
  *Manager Role*
  *Engineer Role*

---

### Step 4: Group Membership Assignment

Each user is automatically:

* Added to their **department group**
* Added to their **role group**

Memberships are derived directly from CSV values.

---

## Resources Created

### Users

* Michael Scott
* Jim Halpert
* Pam Beesly

### Department Groups

* Education Department

### Role Groups

* Manager Role
* Engineer Role

---

## Configuration

### terraform.tfvars

```
tenant_id        = <AZURE_TENANT_ID>
domain_name      = yourdomain.com
default_password = TempPass@123
```

> **Note:**
> The password is temporary. Users must change it during first login.

---

## Execution Steps

```
terraform init
terraform plan
terraform apply
```

---

## Expected Results

* Azure AD users created successfully
* Department and role groups created automatically
* Correct group memberships assigned
* Terraform state updated and consistent

---

## Use Cases

* Employee onboarding automation
* Identity and access management (IAM)
* DevOps automation using Terraform
* Eliminates manual Azure AD administration

---

## Best Practices Followed

* Infrastructure as Code (IaC)
* Dynamic resource creation using `for_each`
* No hardcoded identities
* Idempotent Terraform configuration
* Clear separation of data and logic

---



