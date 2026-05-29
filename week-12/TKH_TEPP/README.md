# 🕵️‍♂️ Technical Environment Provisioning Project (TEPP)

## 📌 Project Overview
This repository holds the forensic analysis, triage logs, and network hardening configurations from my Week 12 Midterm for The Knowledge House Cybersecurity Fellowship. 

Essentially, this was a **Purple Team** simulation where I was dropped into a highly fragile, containerized corporate network stack and tasked with answering two very direct questions: *How did this break, and how do we stop it from happening again?*

## 🏗️ The Infrastructure
The lab setup simulates a corporate network divided into separate subnets (DMZ, Internal, and Triage) using Docker layers. 

* **Host Platform:** Ubuntu 22.04 LTS (A Virtual Machine that tried its absolute best)
* **Container Runtime:** Docker Engine / Containerd
* **Monitoring:** Microsoft Sysmon for Linux (`sysmon.service`)
* **Defensive Tooling:** Netfilter (`iptables`) and AppArmor

---

## 🗂️ Repository Structure

* 📂 **`week-12/`**
  * 📄 **`tepp_postmortem.md`** — The full, deep-dive postmortem report. It has all the exact terminal commands, verified outputs, and formal risk analyses needed to secure a passing grade.
  * 📂 **`screenshots/`** — Visual proof that the infrastructure is actually fixed.

---

## 🛡️ Core Concepts Applied

### 🔴 Red Team (Adversarial Assessment)
* **Manifest Interrogation:** Bypassing a completely non-responsive operating system to extract hardcoded root credentials (`root:admin123`) straight out of a static JSON configuration blueprint using `docker inspect`.
* **Secret Hunting:** Scouring local directory structures to locate exposed cleartext wordlists (`passwords.txt`) and unprotected shell execution histories (`.ash_history`).

### 🔵 Blue Team (Defensive Remediation)
* **Service Hardening:** Forcing an open Redis cache to actually require a password, and locking down a rogue FTP configuration that was allowing anonymous guest write privileges.
* **Perimeter Defense:** Deploying host-level `iptables` rules to drop malicious handshake packets coming from an active adversary subnet (`172.80.0.1`).
* **Compliance Cleaning:** Purging plaintext password files and cleaning tracking logs to eliminate potential lateral movement vectors.

---

## 🗺️ The Lab Journey: What Actually Happened

In a perfect world, incident response follows a clean, predictable manual. In the real world, systems crash, things desynchronize, and you have to think on your feet. Here is the chronology of how this lab went down.

### 🛑 Act I: Emergency Patching
The lab started with a rapid triage of three incredibly misconfigured production servers. Dropping into the live container shells, the baseline security was practically non-existent:
* **`broken_server_1`** was hosting an active Redis store binding openly to the public internet with zero password protection. 
* **`broken_server_2`** was running an FTP server that allowed unauthenticated guests to read and write files globally (`0666`).
* **`broken_server_3`** was keeping a cleartext diary of every single historical deployment command inside the root user's shell history file.

Using targeted string edits (`sed`) and rapid database variables (`redis-cli`), all three servers were brought back into line and locked down within the first hour.

### 💥 Act II: The VM Crash & The Manifest Pivot
Right as the focus shifted to tracking down an active network adversary on **`midterm_target`**, my local host Virtual Machine suffered an unpredicted runtime crash, instantly vaporizing my uncommitted progress tracking sheets. 

Upon recovering the system, the Docker daemon woke up with amnesia. The target container was caught in a stubborn boot-loop, refusing to start due to a low-level routing collision: `Pool overlaps with other one on this address space`. Because the network interface was down, the container couldn't write its traditional log files (`/var/log/auth.log`) to disk.

Instead of panicking or rebuilding the lab, I pivoted. If the container wouldn't start, I just needed to look at the blueprint. By running `sudo docker inspect` directly on the host, I intercepted the static JSON manifest layer. This exposed the original container initialization code in raw text, extracting the weak default credentials (`root:admin123`) and pinpointing the attack subnet (`172.80.0.1`) without the container ever firing a single live network packet.

### 🏁 Act III: The Capstone Audit
With the adversary perimeter blocked via host-level `iptables`, the final phase required a deep dive into **`capstone_target`**. 

Unlike the previous minimal servers, this host was running a heavy corporate footprint backed by a full `systemd` initialization layer and active **Sysmon** logging daemons. A meticulous search through the directory structures caught a major security hazard: an unencrypted wordlist explicitly titled `passwords.txt` floating right in a user's home directory. The file was immediately eradicated using force deletion loops (`rm -f`), cutting off potential lateral credential-stuffing maneuvers and officially concluding the cluster audit.