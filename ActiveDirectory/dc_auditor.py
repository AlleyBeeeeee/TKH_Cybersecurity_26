import os

#use the IP of windows DC
ip_address = "10.0.2.15"

response = os.system(f"ping -c 4 {ip_address}")

with open("/var/log/dc_audit.log", "a") as f:
	if response == 0:
		f.write("DC is UP\n")
	else:
		f.write("DC is DOWN\n")
