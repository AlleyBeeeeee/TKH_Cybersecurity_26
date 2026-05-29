# 🕵️‍♂️ Technical Environment Provisioning Project (TEPP)

## 📌 Project Overview
This repository hosts the infrastructure triage, forensic analysis, and perimeter hardening executed during the Week 12 Midterm for the Cybersecurity Fellowship at The Knowledge House. 

Operating under a **Purple Team** framework, this project simulates a rapid incident response, adversarial tracking, and defensive configuration audit across a containerized enterprise Linux network stack.

## 🏗️ Virtual Architecture & Environment
The lab environment consists of multiple containerized services deployed via Docker layers, simulating separate network segments (DMZ, Internal, and Triage subnets). 

* **Host Platform:** Ubuntu 22.04 LTS (Virtual Machine)
* **Container Environment:** Docker Engine / Containerd Runtime
* **Monitoring Layers:** Microsoft Sysmon for Linux (`sysmon.service`)
* **Security Baselines:** Netfilter (`iptables`), AppArmor Profiles

---

## 🗂️ Repository Structure

* 📂 **`week-12/`**
  * 📄 **`tepp_postmortem.md`** — The complete, deep-dive technical engineering postmortem report containing explicit remediation commands, vulnerability logs, and APA-style enterprise risk analyses.
  * 📂 **`screenshots/`** — Documented forensic evidence captures verifying before/after system states.

---

## 🛡️ Core Purple Team Disciplines Demonstrated

### 🔴 Red Team (Adversarial Assessment)
* **Metadata Interrogation:** Extracting hardcoded initialization credentials (`root:admin123`) from non-running container structures using `docker inspect`.
* **Privilege & Secret Hunting:** Running recursive filesystem scans (`find`) to locate exposed plaintext wordlists (`passwords.txt`) and unprotected execution buffers (`.ash_history`).

### 🔵 Blue Team (Defensive Remediation)
* **Service Hardening:** Enforcing string authentication layers on exposed Redis key-value stores and disabling guest mapping/write parameters on rogue FTP configurations.
* **Perimeter Defense:** Deploying `iptables` packet filters to dynamically track connection states and drop rogue handshake strings from targeted attacker subnets (`172.80.0.1`).
* **Compliance Cleaning:** Executing total data sanitization routines to wipe sensitive command trails and unencrypted wordlists from persistent user directories.

---

## 🗺️ The Incident Response Journey: Chronology of the Lab

Every incident response engagement is fluid, chaotic, and rarely goes strictly according to a manual. Below is the operational timeline of how this network stack was audited, stabilized, and recovered under pressure.

### 🛑 Act I: The Initial Triage & Emergency Patching
The mission began with a rapid-response triage of three heavily misconfigured production assets. Dropping directly into the live container shells, immediate system checks revealed massive, open security gaps:
* **`broken_server_1`** was running a wide-open memory cache backend with absolutely no password tracking.
* **`broken_server_2`** was actively inviting unauthenticated guest drop-offs over FTP with globally insecure default write permissions.
* **`broken_server_3`** was leaking past administrative deployment commands in cleartext via root shell histories.

Using structural string-edits (`sed`) and runtime configuration manipulations (`redis-cli`), all three servers were locked down, isolated, and verified secure within the first hour of operations.

### 💥 Act II: The VM Crash & Out-of-Box Reverse Engineering
Just as the investigation shifted to **`midterm_target`** to trace an active network adversary, the underlying local Virtual Machine suffered an unpredicted, catastrophic runtime crash, wiping out the uncommitted markdown progress sheets. 

Upon restarting the hypervisor, the Docker network stack desynchronized. The `midterm_target` container was caught in a stubborn initialization boot-loop, refusing to start due to a low-level routing collision error: `Pool overlaps with other one on this address space`. Because the container network interface was completely down, standard log files (`/var/log/auth.log`) could not write to disk. 

Rather than abandoning the lab state or wiping the progress, a **Purple Team engineering pivot** was executed. The raw container configuration layers were interrogated directly from the host filesystem configuration database using `sudo docker inspect`. This reverse-engineered the underlying initialization launch strings (`"Cmd"` / `"Args"` properties) hidden inside the static JSON manifest, successfully extracting the hardcoded default compromise metrics (`root:admin123`) and identifying the target attack subnet (`172.80.0.1`) without the container ever firing a single live network packet.

### 🏁 Act III: The Capstone Audit & Final Containment
With the adversary vectors mapped and neutral firewalls deployed via host-level `iptables`, the final phase required a deep dive into the active enterprise footprint of **`capstone_target`**. 

Unlike the previous stripped-down deployments, this target container ran a dense, realistic environment backed by a full `systemd` init layer and active enterprise monitoring daemons (**Sysmon**). A focused recursive search through user home directories flagged a massive lingering operational risk: a raw, cleartext dictionary wordlist titled `passwords.txt`. The asset was immediately wiped using force deletion loops (`rm -f`), successfully removing lateral credential-stuffing capabilities and finalizing the structural security posture of the cluster.
