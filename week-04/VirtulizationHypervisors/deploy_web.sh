#!/bin/bash
# ==================================================
# SESSION 11: THE DISPOSABLE WEB SERVER
# Operator Deployment Script
# ==================================================

echo "[*] Initiating Container Deployment..."

# INSTRUCTION: Write the exact Docker command below to run the nginx image in detached mode,
# name it "training-web", and map port 8080 on the host to port 80 on the container.
# YOUR COMMAND HERE:
docker run -d --name training-web -p 8080:80 nginx

#What is happening here is you are creating a Bash Script, which is essentially a "to-do list" for your computer.
# Instead of you having to manually type out that long Docker command every time you want to start your server, you’ve now "programmed" your Ubuntu host 
#to do it for you. When you run this script in the future, it will follow your instructions in order: first, it prints the "Initiating" message 
#to your screen, then it talks to the Docker engine to pull the image and launch your isolate	d container in the background, and finally,
# it confirms success. This is the first step toward Infrastructure as Code (IaC)—a key cybersecurity and DevOps concept where you use scripts to
# deploy secure, identical environments instantly and without human error.

echo "[+] Deployment command executed."
