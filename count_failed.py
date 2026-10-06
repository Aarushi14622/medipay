counts = {}

with open("/var/log/auth.log") as log:
	for line in log:
		if "Failed password" in line or "Invalid user" in line:
			words = line.split()
			ip = words[words.index("from") + 1]
			counts[ip] = counts.get(ip, 0) + 1
for ip, total in counts.items():
    if total >= 3:
        print("ALERT:", ip, "failed", total, "times")
