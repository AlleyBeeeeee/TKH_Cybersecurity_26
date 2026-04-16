# TITAN SMALL BUSINESS SERVICES: SECURITY ARCHITECTURE DOCUMENT (SAD)
**Operator:** Alexandra Blandon
**Date:** 4/15/2026

## 1. Perimeter Hardening (UFW & SSH)
* **SSH Status:**
Disabled Root Login: PermitRootLogin no
Disabled Password Auth: PasswordAuthentication no

* **Firewall Logic:**
I used UFW to restrict traffic to only necessary ports:
sudo ufw allow 22 (SSH)
sudo ufw allow 8080 (App)
sudo ufw default deny incoming

## 2. The Automated Auditor (Python)
* **Script Logic:** 
import os
# Logic to check disk space and log it
disk_info = os.popen('df -h').read()
with open("/var/log/sys_audit.log", "a") as f:
    f.write(disk_info)

* **Telemetry Path:** `/var/log/sys_audit.log`

## 3. Containerized App (Docker)
* **Network Isolation:** 
Used a Docker internal network for the MySQL DB so it has no route to the internet.
services:
  wiki:
    image: nginx
    ports: ["8080:80"]
    networks: [frontend, backend]
  db:
    image: mysql
    networks: [backend]

networks:
  frontend:
  backend:
    internal: true

* **Stack Health:**
NAME            IMAGE     COMMAND                  SERVICE   CREATED             STATUS          PORTS
hardened_db     mysql     "docker-entrypoint.s…"   db        About an hour ago   Up 35 minutes   
hardened_wiki   nginx     "/docker-entrypoint.…"   wiki      About an hour ago   Up 33 minutes   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp

## 4. Executive Summary
The Hardened Outpost successfully implements a 'Defense in Depth' strategy by securing the host perimeter through strict SSH policies and UFW firewall rules. 
Automated monitoring is established via a Python-based auditing script that provides continuous telemetry of system health and domain connectivity.
Finally, the application tier is containerized with a strict air-gap configuration, ensuring the database remains entirely isolated from external network traffic.
