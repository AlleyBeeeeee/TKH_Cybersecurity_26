#!/bin/bash

#Foundations Lab Final - Infrastructure Audit Script
#Purpose: To Verify environment setup and generate a deployment artifact.

echo "Starting system audit..."

#Create or overwrite the audit log
echo "--- Infrastructure Audit Log ---" > setup_verify.txt
echo "Timestamp: $(date)" >> setup_verify.txt
echo "User: $(whoami)" >> setup_verify.txt
echo "Current Directionary: $(pwd)" >> setup_verify.txt

#Check for the existence of the Network artifact
if [ -f "network_topology.pkt" ] || [ -f "netowork_topology.png" ]; then 
	echo "Networking Deliverable: FOUND" >> setup_verify.txt
else
	echo "Networking Deliverable: NOT FOUND (Reminder: Add your Packet Tracer file to this folder)" >>setup_verify.txt
fi

echo "Audit complete. Results saved to setup_verify.txt"
