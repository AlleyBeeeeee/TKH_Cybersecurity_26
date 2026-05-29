# Technical Environment Provisioning Project (TEPP) Postmortem
**Fellow:** Alexandra Blandon  
**Date:** May 28, 2026  
**Course:** Cybersecurity Fellowship — Week 12 Midterm  

---

## Phase 1: Rapid Triage & Remediation

### Server 1: broken_server_1 (172.100.0.11) — Exposed Redis Store

* **Vulnerability Confirmed:** Unauthenticated remote access to Redis key-value storage engine (version 8.6.3) binding openly to `0.0.0.0:6379`.
* **Container Entry Command:**
    ```bash
    sudo docker exec -it broken_server_1 sh
    ```
* **Remediation Commands:**
    ```bash
    redis-cli CONFIG SET requirepass "HardenedM1dterm2026!"
    ```
* **Before/After State Documentation:**
    * *Before:* Execution of localized system diagnostics (`ps aux`) verified the engine process initialized without an explicit structural configuration file, natively permitting arbitrary global query parsing.
    * *After:* Direct command transmission strings returned a protective runtime termination string: `(error) NOAUTH Authentication required.`
* **Enterprise Risk Analysis (APA Style):**
    Exposing an unauthenticated database interface to production or staging subnets compromises fundamental data integrity and confidentiality frameworks within an enterprise infrastructure. Adversaries gaining access to an open memory-cache registry can execute arbitrary data exfiltration operations, poison pipeline variables, or weaponize localized write directives to achieve unauthenticated remote code execution (RCE). Enforcing systemic string authentication parameters alongside local routing boundaries guarantees that access layers conform strictly to the principle of least privilege.

---

### Server 2: broken_server_2 (172.100.0.12) — Rogue FTP Configuration

* **Vulnerability Confirmed:** Misconfigured `vsftpd` (version 3.0.2) instance allowing over-privileged guest mapping (`guest_enable=YES`), writeable root directory escapes (`allow_writeable_chroot=YES`), and a globally insecure default file-creation mode (`file_open_mode=0666`).
* **Container Entry Command:**
    ```bash
    sudo docker exec -it broken_server_2 bash
    ```
* **Remediation Commands:**
    ```bash
    sed -i 's/guest_enable=YES/guest_enable=NO/' /etc/vsftpd/vsftpd.conf
    sed -i 's/allow_writeable_chroot=YES/allow_writeable_chroot=NO/' /etc/vsftpd/vsftpd.conf
    sed -i 's/file_open_mode=0666/file_open_mode=0644/' /etc/vsftpd/vsftpd.conf
    ```
* **Before/After State Documentation:**
    * *Before:* A `grep -v '^#'` configuration dump verified guest access mapped to local systemic privileges with global write rights, presenting an unauthenticated file-system write vector.
    * *After:* Executing a host-level container restart (`sudo docker restart broken_server_2`) reinitialized the runtime environment, forcing the application daemon to parse the newly restrictive configuration parameters.
* **Enterprise Risk Analysis (APA Style):**
    Permitting unauthenticated or overly loose write privileges within file transfer protocol architectures introduces severe vulnerabilities to internal network segments. Adversaries can exploit writeable chroot configurations and permissive creation masks to drop malicious binary structures, plant persistent web shells, or override critical application logic configurations. Enforcing standard read-only boundaries and secure creation masks (`0644`) preserves the system's operational integrity and stops lateral staging maneuvers across the enterprise directory structure.

---

### Server 3: broken_server_3 (172.100.0.13) — Local Administrative Log Leak

* **Vulnerability Confirmed:** Sensitive system configuration data and administrative artifacts exposed via an active, unprotected shell command history file (`/root/.ash_history`) updated concurrently with system initialization.
* **Container Entry Command:**
    ```bash
    sudo docker exec -it broken_server_3 sh
    ```
* **Remediation Commands:**
    ```bash
    rm -f /root/.ash_history
    ```
* **Before/After State Documentation:**
    * *Before:* A localized directory metadata search (`ls -la /root`) verified the presence of an active `.ash_history` shell artifact tracking structural deployment commands in cleartext.
    * *After:* Execution of targeted file deletion directives (`rm -f`) purged the transient storage structure, returning a verified null file path error string upon subsequent access attempts.
* **Enterprise Risk Analysis (APA Style):**
    Retaining unprotected administrative or shell command execution history logs within container environments introduces severe operational vulnerabilities. If an adversary gains low-privilege runtime code execution via adjacent services, they can extract plaintext configuration flags, API tokens, and hardcoded back-end microservice credentials directly from transient logging buffers. Wiping deployment logs and enforcing strict historical logging omissions represents a key standard required to maintain baseline compliance in cloud-native operational footprints.

### 4. Final Analytical Summary

This simulated compromise provides critical insights into infrastructure defense, demonstrating that perimeter-only network filtering is entirely incapable of securing an enterprise environment if internal nodes lack rigorous configuration baselines. The ease with which a single Layer-7 input validation flaw was leveraged to establish an active reverse shell highlights the danger of running internal services, such as database or file transfer engines, without robust local authentication controls.

This incident clearly underscores that internal zones must be treated with zero inherent trust, necessitating continuous service isolation and behavioral auditing across all subnets. To fully neutralize this specific breach vector at its source, the single most effective control would be the implementation of strict parameterized input validation combined with an explicit application allowlist within the web server’s codebase. By enforcing a rigorous validation schema that rejects any shell metacharacters or unauthorized system commands, the web application would render input tampering attempts completely inert, effectively preventing the execution of arbitrary payloads regardless of underlying system privileges or downstream firewall configurations.

---

## Phase 2: Forensic Analysis & Perimeter Hardening

### Target: Breach Network Host — midterm_target (172.80.0.10)

* **Incident Timeline & Identification Summary:**
    * **Target Account:** `root`
    * **Compromised Access Vector:** Insecure Password Authentication via SSH (Port 22)
    * **Identified Secret/Password:** `admin123`
    * **Adversary Source Address:** `172.80.0.1`

* **Remediation Script (Netfilter/iptables Configuration):**
    ```bash
    # Step 1: Drop all ingress SSH traffic from the confirmed attacker source IP
    sudo iptables -A INPUT -p tcp -s 172.80.0.1 --dport 22 -j DROP

    # Step 2: Enforce strict connection tracking to drop illegitimate handshake strings
    sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
    ```

* **Enterprise Risk Analysis (APA Style):**
    Allowing remote root administrative authentications using weak string parameters (`admin123`) violates core infrastructure containment principles. Threat actors can deploy automated dictionary brute-force arrays to quickly compromise exposed shell instances. Once inside, they assume complete systemic authorization, enabling them to wipe logging partitions, manipulate core packet filtering structures, or move laterally across neighboring virtualization clusters. Disabling plaintext root authentication (`PermitRootLogin no`), enforcing cryptographic key pairs, and establishing host-level packet filters (`iptables`) mitigates unauthorized administrative access models across enterprise networks.
    
    ---

## Phase 3: Capstone Infrastructure Audit

### Target: Enterprise Host — capstone_target (172.100.0.14)

* **Vulnerability Confirmed:** Plaintext credential wordlist storage located within a standard user home space configuration partition (`/home/abeee/passwords.txt`).
* **Container Entry Command:**
    ```bash
    sudo docker exec -it capstone_target bash
    ```
* **Remediation Commands:**
    ```bash
    rm -f /home/abeee/passwords.txt
    ```
* **Before/After State Documentation:**
    * *Before:* Executing a recursive file find sequence (`find /home -type f`) identified an unencrypted text asset populated with default dictionary strings, presenting a massive privilege escalation or lateral stuffing vector.
    * *After:* Executing a targeted force deletion command (`rm -f`) successfully cleared the artifact, returning a null location error upon subsequent system query attempts.
* **Enterprise Risk Analysis (APA Style):**
    Retaining plaintext credential logs or custom wordlist structures inside default directory trees exposes an enterprise environment to severe data breach risks. Adversaries leveraging initial, low-privilege access anchors can scrape local filesystems to extract text files, bypassing authorization layers without generating traditional system events. Implementing automated configuration auditing tools, sanitizing user landing folders, and enforcing strict data-at-rest encryption practices ensures environment segments maintain alignment with defense-in-depth infrastructure parameters.