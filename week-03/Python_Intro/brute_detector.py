attack_count = 0 

# Open the source log as 'r' (magnifying glass)
# Open the report as 'w' ( the eraser - creates a fresh file)

with open("auth_audit.log", "r") as log_file:
	with open("brute_report.txt", "w") as report_file:

	# the conveyor belt (the loop)
		for line in log_file:

          #   the signature search - we only care about the lines containing failed passwor
			if "Failed password" in line:
		# the save
				report_file.write(line)
		# increment counter
				attack_count = attack_count + 1

print(f"[*] Audit Complete. Extracted {attack_count} threat signatures to brute_report.txt")
