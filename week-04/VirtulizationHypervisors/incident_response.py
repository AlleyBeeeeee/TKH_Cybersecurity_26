#!/usr/bin/env python3
import subprocess
import json

print("[*] Initiating Automated Threat Hunt...")

# TASK 1: Use subprocess to grep for "Failed password" in /var/log/titan_sim/auth_sim.log
# Ensure you capture the output and convert it to text!
# YOUR CODE HERE:
# Run the grep command and capture what it finds
result = subprocess.run(
    ["grep", "Failed password", "/var/log/titan_sim/auth_sim.log"],
    capture_output=True,
    text=True
)

# Save the captured text to raw_output
raw_output = result.stdout

# TASK 2: Parse the captured output to extract ONLY the attacking IP addresses.
# Hint: Loop through each line, split the line by spaces, and grab index [10].
# Save the IPs to a Python List called attacker_ips.
# YOUR CODE HERE:
# 1. Split the big block of text into a list of individual lines
lines = raw_output.split('\n')

# 2. Initialize an empty list to store our findings
attacker_ips = []

# 3. Loop through each line to extract the IP
for line in lines:
    if line:  # This ensures we don't process empty lines at the end of the file
        parts = line.split(" ")
        # The IP address is at index 10 (the 11th word in the line)
        ip = parts[10]
        attacker_ips.append(ip)

# TASK 3: Create a dictionary containing the extracted IPs and export it to 'threat_report.json'
# Dictionary format: {"alert_type": "Brute Force", "attacker_ips": attacker_ips}
# YOUR CODE HERE:
# 1. Create a Python dictionary (key-value pairs)
alert_data = {
    "alert_type": "Brute Force",
    "attacker_ips": attacker_ips
}

# 2. Open a new file called 'threat_report.json' in write mode ('w')
with open("threat_report.json", "w") as file:
    # 3. Convert the dictionary to JSON format and save it
    json.dump(alert_data, file, indent=4)

print("[+] Mission Complete: threat_report.json generated.")

print("[+] Threat Hunt Complete. Report generated.")
