import sys  # Allows the script to take inputs from the terminal
from scapy.all import ICMP, IP, sr1  # Tools to build and send network packets
from netaddr import IPNetwork  # Tool to turn a subnet (like /24) into a list of IPs

def ping_sweep(network, mask):
    live_hosts = []  # A 'bucket' to store the IP addresses that respond
    
    # Create the network range (e.g., 192.168.1.0/24)
    # The f"{}" part combines the text and variables together
    hosts_list = IPNetwork(f"{network}/{mask}")

    print(f"Scanning {network}/{mask}...")

    # .iter_hosts() goes through every usable IP address one by one
    for host in hosts_list.iter_hosts():
        
        # Build the packet: IP layer (destination) + ICMP layer (the ping)
        # str(host) converts the IP object into plain text
        packet = IP(dst=str(host))/ICMP()
        
        # sr1: Send packet and wait for 1 response. 
        # timeout=1 means wait 1 second before giving up.
        # verbose=0 keeps the screen from filling with messy Scapy logs.
        response = sr1(packet, timeout=1, verbose=0)

        # If 'response' is not empty, it means the host answered!
        if response:
            print(f"Host {host} is UP!")
            live_hosts.append(str(host)) # Save the live IP to our bucket
        
    return live_hosts # Hand back the final list of live IPs

# This is the "Start Button" of the script
if __name__ == "__main__":
    
    # Grab the network and mask from the command you type in the terminal
    # sys.argv[1] is the 1st thing you type after the filename
    target_net = sys.argv[1] 
    target_mask = sys.argv[2]

    # Run the function we built above and store the results
    found_ips = ping_sweep(target_net, target_mask)

    # Print a final summary
    print(f"\nScan finished. Found {len(found_ips)} active hosts.")
    for ip in found_ips:
        print(f" -> {ip}")
