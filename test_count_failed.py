from count_failed import count_failed_logins


def test_counts_failed_logins_per_ip():
	fake_lines = [
	 "sshd[1]: Invalid user hacker from 10.0.0.5 port 1111",
     	 "sshd[2]: Invalid user admin from 10.0.0.5 port 2222",
       	 "sshd[3]: Failed password for root from 10.0.0.5 port 3333",
       	 "sshd[4]: Accepted publickey for ubuntu from 10.0.0.9 port 4444",
    ]

	assert count_failed_logins(fake_lines) == {"10.0.0.5": 3}


def test_no_failures_returns_empty():
	fake_lines = [
		"ssh[1]: Accepted publickey for ubuntu from 10.0.0.9 port 4444",
	]
	assert count_failed_logins(fake_lines) == {}
