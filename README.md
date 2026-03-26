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

TKH_Cybersecurity_26/
├── Linux_Intro/           # Week 01 - Bash & System Hardening
│   ├── discovery.txt      
│   ├── threat_ips.txt     
│   └── harden.sh          
├── Network_Ops/           # Week 02 - Networking & Auditing
│   ├── network_audit.txt  
│   ├── subnet_blueprint.txt 
│   └── protocol_audit.txt 
├── Python_Intro/          # Week 03 - Automation Scripts
│   ├── port_check.py      
│   └── brute_detector.py  
├── ICMP_Practice/         # Post-Week 03 Reconnaissance
│   └── ping_sweeper.py    
├── network_topology.pkt   # Cisco Packet Tracer Lab
└── README.md

| Week | Theme | Status |
| :--- | :--- | :--- |
| **01** | Terminal · Permissions · Stream Editing · Git | ✅ |
| **02** | Networking · Subnetting · Protocol Interrogation | ✅ |
| **03** | Python Scripting · Port Scanner · Brute Force Detector | ✅ |
| **04** | Virtualization · Docker · Container Security | ⏳ |

---

## 🛠️ Weekly Laboratory Deep Dives

### 🛡️ [Week 01] — Linux Foundations
> **Technical Implementation:** `Linux_Intro/harden.sh`
> 
> **Focus:** Principle of Least Privilege. I learned to audit SUID/GUID bits and manage file permissions (`chmod`, `chown`) to secure sensitive system files like `/etc/shadow`.
* **Action:** Created `harden.sh` to automate the securing of a fresh Ubuntu VM.
* **Key Skill:** Pipeline chaining using `grep`, `awk`, and `sed` to filter 10,000+ log lines into a clean `threat_ips.txt`.

---

### 📡 [Week 02] — Network Defense
> **Technical Implementation:** `Network_Ops/network_topology.pkt`
> 
> **Focus:** Transitioned from local system security to network-wide governance. I learned the mechanics of the OSI Model and how to design defensible network architectures.
* **Action:** Designed a segmented network in Cisco Packet Tracer and performed protocol interrogation using `ss -tuln` and `dig`.
* **Key Skill:** Calculating CIDR notation and subnet masks to ensure proper network isolation (Subnetting).

---

### 🐍 [Week 03] — Python for Security
> **Technical Implementation:** `Python_Intro/port_check.py` & `brute_detector.py`
> 
> **Focus:** Moved from manual terminal commands to **Security Automation**. I learned how to use Python's `socket` and `file I/O` libraries to build custom defensive tools.
* **Action:** Developed a custom port scanner to identify open vectors and a forensic script to parse `auth.log` files for brute-force patterns.
* **Key Skill:** Using `try/except` blocks for error handling and automating raw log conversion into structured reports.

---

### 🏗️ Technical Environment & Governance
| Component | Specification |
| :--- | :--- |
| **Guest OS** | Ubuntu 24.04 LTS |
| **Hardware** | Samsung T7 SSD (High-speed VM performance) |
| **Frameworks** | NIST CSF, CIA Triad, AAA (Auth, Auth, Accounting) |

---

**Built intentionally · Current Status: Updated weekly · TKH IF 2026**