# TARGET THREAT PROFILE: CloudNano 
**Classification:** Passive Security Audit
**Operator:**  Alexandra
* **Tool Used:** Sublist3r
* **Subdomains Found:** * toolbox.tesla.com
   workforce.tesla.com *

# 2. Tech Stack Mapping 
* **Tool Used:** BuiltWith / Wappalyzer
* **Identified Technologies (CMS/CDN/Backend):** * Drupal, Akamai, React *

## 3. Major Exposure Points & Dangers 
*(List three major exposure points discovered during your OSINT audit and explain why they are dangerous)*
1. **[Exposure Point 1]:** Outdated Software - Using deprecated software (like the vsFTPd 2.3.4 we saw earlier) is a major risk because these versions have publicly known vulnerabilities (CVEs). 
Attackers can use automated scripts to exploit these "backdoors" and gain full control of the server without needing a password.
2. **[Exposure Point 2]:** Exposed login portals - Services like Remote Desktop (RDP) on port:3389 should never be visible to the entire internet. 
Having them exposed allows hackers to attempt Brute Force attacks (guessing passwords repeatedly) or use "Zero-Day" exploits to bypass the login screen entirely and enter the internal network.
3. **[Exposure Point 3]:** Leaked Credentials - When employee emails are found in third-party data breaches, it suggests they may be reusing passwords across multiple sites.
An attacker can perform a Credential Stuffing attack, using those leaked passwords to try and log into the company's actual VPN or cloud infrastructure.
