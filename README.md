# Foundations_Lab_Final: Cybersecurity Infrastructure & Governance

**Student:** Alexandra Blandon  
**Milestone:** Night 1 - Technical Identity & Workbench  
**Date:** February 25, 2026

---

## 🛡️ Core Security Philosophy

I believe that cybersecurity is not just a technical barrier, but a foundational layer of trust. My approach focuses on **Security by Design**, where governance (the "Why") and technical implementation (the "What") are aligned to protect decentralized digital ecosystems.

---

## 🛠️ Technical Framework Mapping (CIA & AAA)

This lab environment is governed by the following frameworks to ensure a defensible security posture:

### Principle Implementation in this Lab

- **Confidentiality:** Use of Private GitHub Repositories and **Least Privilege** access in Ubuntu VMs.
- **Integrity:** Git Version Control provides a **cryptographic audit trail** for all documentation and code.
- **Availability:** Cloud-based backups (GitHub) and local VM exports ensure data is accessible after hardware failure.
- **Authentication:** Secure login to the Ubuntu VM and **MFA** on the GitHub account.
- **Authorization:** Restricted `sudo` permissions within the Linux environment to prevent unauthorized system changes.
- **Accounting:** Git Commit logs and `lab_verify.sh` logs act as the primary audit record of work performed.

---

## ⚖️ Governance & Reflection

Governance provides the rules of engagement for technical tools. While a technician can configure a firewall, governance determines which traffic should be blocked based on **risk assessment**. In this lab, tonight's material aligns with the **GRC (Governance, Risk, and Compliance)** domain, bridging the gap between business goals and technical implementation.

---

## 📚 Professional Research Standards (APA 7th)

_Center for Internet Security_. (2021). _CIS Controls v8: A Priority Set of Logical Safeguards_. https://www.cisecurity.org/controls/v8

_National Institute of Standards and Technology_. (2018). _Framework for Improving Critical Infrastructure Cybersecurity_ (Version 1.1). U.S. Department of Commerce. https://doi.org/10.6028/NIST.CSWP.04162018

Anderson, J. (2003). _Why Information Security is Hard - An Economic Perspective_.

---

## 🚀 Night 1 Deployment Status

- **Hypervisor:** VirtualBox (running on Samsung T7 SSD)
- **Guest OS:** Ubuntu 24.04 LTS
- **Automation:** `lab_verify.sh` successfully executed.
