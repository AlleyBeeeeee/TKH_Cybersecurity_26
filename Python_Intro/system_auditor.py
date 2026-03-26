#!/usr/bin/env python3
import subprocess
import json
import os

print("[*] Initiating System Audit...")

# INSTRUCTION 1: Use subprocess.run() to execute 'ps aux'
# YOUR CODE HERE:
process_list = subprocess.run(["ps", "aux"], capture_output=True, text=True)
# WHY: We need to see every process running on the system to find the threat.
# HOW: We use a list ["ps", "aux"] because subprocess.run prefers separate arguments.

# INSTRUCTION 2: Search the captured output for the malicious process
# YOUR CODE HERE:
if  "unauthorized_cryptominer" in process_list.stdout:

# INSTRUCTION 3: If found, create a dictionary and save it to 'security_alert.json'
# YOUR CODE HERE:
	alert_data = {
		"event": "Unauthorized Process",
		"severity": "High",
		"process": "unauthorized_cryptominer"
}

# the export
# with: Think of this as a safety contract. It tells Python, "Keep this file open while I'm working, but the second I'm done (or if I crash), slam it shut so the data isn't corrupted."
#"security_alert.json": This is the name of the new physical file on your hard drive.
#"w": This stands for Write. It tells the computer to create a fresh file.
#as file: This is just a temporary nickname for the open file so we can talk to it in the next line. 
	with open("security_alert.json", "w") as file:
		json.dump(alert_data, file, indent=4) #indent 4 makes the file human-readable
#json.dump: This is the "Translator." How do you turn a Dictionary into a file? Which tool handles that translation? It’s this function! It takes your Python-specific dictionary (alert_data) and converts it into the universal JSON language.
#alert_data: The source material (your dictionary).
#file: The destination (the file nickname we just made).
#indent=4: This is why your output looks so clean with those spaces on the left! Without this, the entire JSON would be one long, hard-to-read line.
	print("ALERT: Unauthorized process detected! Artifact created.")  #feedback for the user
else:
	print("Audit complete. No unauthorized processes found.") 

print("[+] Audit Complete.")
