#!/bin/bash
# TLAB 8 Provisioning: Deep Pivot Sandbox & PrivEsc Misconfiguration

if [[ $EUID -ne 0 ]]; then 
    echo "[-] Error: This script must be run with sudo."
    exit 1
fi

TARGET_USER=${SUDO_USER:-$(logname 2>/dev/null || echo $USER)}
USER_HOME=$(eval echo ~$TARGET_USER)

echo "[*] Initializing Operation Deep Pivot for operator: $TARGET_USER..."

# 1. Ensure Tooling is Installed
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -yq proxychains nmap metasploit-framework > /dev/null 2>&1
systemctl start postgresql > /dev/null 2>&1

# 2. Build the Multi-Tier Network (The Sandbox)
docker rm -f bastion_web vault_db > /dev/null 2>&1
docker network rm dmz_net vault_net > /dev/null 2>&1

docker network create --subnet=172.60.0.0/24 dmz_net > /dev/null 2>&1
docker network create --internal --subnet=10.0.10.0/24 vault_net > /dev/null 2>&1

# 3. Deploy Target 1: The Bastion Web Server
# Custom build to inject a low-level user with a specific Sudo vulnerability (awk)
mkdir -p /tmp/bastion_build
cat << 'DOCKERFILE' > /tmp/bastion_build/Dockerfile
FROM rastasheep/ubuntu-sshd
RUN useradd -m -s /bin/bash mercenary && echo "mercenary:titan123" | chpasswd
RUN apt-get update && apt-get install -y sudo awk
RUN echo "mercenary ALL=(root) NOPASSWD: /usr/bin/awk" > /etc/sudoers.d/mercenary_awk
RUN chmod 0440 /etc/sudoers.d/mercenary_awk
DOCKERFILE

docker build -t bastion_target /tmp/bastion_build > /dev/null 2>&1
docker run -d --name bastion_web --net dmz_net --ip 172.60.0.10 bastion_target > /dev/null 2>&1
docker network connect --ip 10.0.10.10 vault_net bastion_web

# 4. Deploy Target 2: The Air-Gapped Database
docker run -d --name vault_db --net vault_net --ip 10.0.10.50 redis:alpine > /dev/null 2>&1

# 5. Artifact Generation: Markdown Skeleton
cat << 'MD_EOF' > "$USER_HOME/Deep_Pivot_Report.md"
# OPERATION DEEP PIVOT: AFTER ACTION REPORT
**Operator:** ## PHASE 1: PRIVILEGE ESCALATION
* **Initial Access User:** mercenary
* **Vulnerable Sudo Binary:** [Insert the binary you found using sudo -l]
* **GTFOBins Exploit Command Used:** [Insert the exact command used to become root]

## PHASE 2: PERSISTENCE
* **Cron Syntax Used:** [Insert the exact line you added to the crontab]
* **Persistence Confirmed:** (Yes/No)

## PHASE 3: LATERAL MOVEMENT (THE PIVOT)
* **Metasploit Modules Used:** [List the autoroute and proxy modules]
* **Hidden Database IP Discovered:** [Insert the IP of the vault_db on the 10.0.10.x network]
* **Open Port on Hidden Database:** [Insert the port discovered via proxychains nmap]
MD_EOF

chown $TARGET_USER:$TARGET_USER "$USER_HOME/Deep_Pivot_Report.md"

echo "[+] PROVISIONING COMPLETE."
echo "[+] Bastion Web is accessible at 172.60.0.10 (User: mercenary / Pass: titan123)"
echo "[+] Vault DB is hidden on the 10.0.10.0/24 subnet."
echo "[+] TLAB Artifact template seeded at: ~/Deep_Pivot_Report.md"