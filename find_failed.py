with open("sample_auth.log") as log:
	for line in log:
		if "Failed password" in line:
			print(line.strip())
