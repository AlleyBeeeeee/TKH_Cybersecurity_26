import socket

#List of Servers
targets = ["127.0.0.1", "8.8.8.8", "1.1.1.1", "10.0.0.1", "192.168.1.1"]

for ip in targets:
	print(f"---Checking Server: {ip} ---")

#1 . Create the hand
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

#2. Set the timer
	s.settimeout(1)

#3. Knock on Port 22 (SSH)
	result = s.connect_ex((ip, 22))

#4 Interpret the result: 0 mean  "Open" anything else means 'closed'
	if result == 0:
		print(f"Success: Port 22  is OPEN on {ip}")
	else:
		print(f"Failed: Port 22 is CLOSED on {ip}")

# close connection
	s.close()
