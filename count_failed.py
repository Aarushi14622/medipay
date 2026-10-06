def count_failed_logins(lines):
    counts = {}
    for line in lines:
        if "Failed password" in line or "Invalid user" in line:
            words = line.split()
            ip = words[words.index("from") + 1]
            counts[ip] = counts.get(ip, 0) + 1
    return counts


if __name__ == "__main__":
    with open("/var/log/auth.log") as log:
        counts = count_failed_logins(log)
    for ip, total in counts.items():
        if total >= 3:
            print("ALERT:", ip, "failed", total, "times")
