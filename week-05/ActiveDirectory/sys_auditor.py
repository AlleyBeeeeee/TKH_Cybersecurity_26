import os

#define log path
log_file = "/var/log/sys_audit.log"

#get disk space usage use read to capture the commands output string
disk_info = os.popen('df -h').read()

#write the output to log file 
try:
	with open(log_file, "a") as f:
		f.write("\n--- System Audit Report --- \n")
		f.write(disk_info)
		f.write("-" * 27 + "\n")
	print(f"Audit successful. Results saved to {log_file}")
except PermissionError:
	print("Error: You need to sudo privileges to write to /var/log")
