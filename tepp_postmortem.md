# TEPP The Final Reckoning: Postmortem & Incident Response Report
**Author:** Alexandra Blandon
**Course:** TKH Cybersecurity '26 
**Date:** May 26, 2026  

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


