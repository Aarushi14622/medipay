# Decision log

What was decided, why, and what was rejected. Newest at the bottom.

| # | Date | Decision | Why | Rejected |
|---|---|---|---|---|
| D1 | Oct 2026 | Target technical GRC / TPRM roles | Matches the pivot. Technical labs are the differentiator | Also applying as a DevSecOps engineer (dilutes the CV) |
| D2 | Oct 2026 | Technical work at beginner, understand-it depth | Learning how controls work and what can go wrong, not building production pipelines | Production-level labs, big file dumps, memorising commands |
| D3 | Oct 2026 | One repo, one fictional organisation (MediPay) | Technical evidence and TPRM deliverables tell one story | Two separate projects |
| D4 | Oct 2026 | Cut Postgres, observability, ML. ECS optional | Developer or SRE work, low GRC value | — |
| D5 | Oct 2026 | Semgrep out of the venv. Lockfiles from clean venvs | Scanner and app needed incompatible dependency versions | Freezing the working venv |
| D6 | Oct 2026 | Merge the Patients service with documented gaps (no auth, logging, rate limiting) | First version, synthetic data. Risks recorded with owners and plans | Blocking the PR |
| D7 | 24 Oct 2026 | Docker from Ubuntu apt (`docker.io`). User in the `docker` group | Same trusted source as other system tools. The group is root-equivalent but acceptable on a disposable lab VM | Docker Desktop on the Mac. Adding Docker's own apt repo (another supplier to trust) |
| D8 | 14 Nov 2026 | **Speed over polish:** build the structure through Day 10 in one go, with Claude drafting. I review, verify and learn from the PRs | Interview-ready as fast as possible | Continuing one small step per day (too slow for the goal) |
| D9 | 14 Nov 2026 | **No real AWS account.** The baseline is written as Terraform and scanned only. Prowler is cut | Cost, a personal sign-up, and the scanning evidence is enough for a GRC role | Creating the account on Day 5 as originally planned |
| D10 | 14 Nov 2026 | **Sector: healthcare** | Fits MediPay. Synnovis is a clear UK supply chain incident. Health data is special category | Finance (would need a new scenario) |
| D11 | 14 Nov 2026 | **MediPay is not a designated critical supplier, but acts as if it could be** | Billing disruption delays revenue, not care, so designation is unlikely. NHS customers will ask the same questions anyway | Assuming designation (overclaims). Ignoring the Bill (misses the point) |
| D12 | 14 Nov 2026 | Accept a **base image rebuild younger than two weeks** (python:3.12-slim, 8 Nov 2026) and patch `zlib1g` from Debian security | Security fixes for HIGH CVEs. The two-week rule protects against *new features and versions*, not against applying a vendor's own security rebuild | Waiting two weeks with known fixable HIGH vulnerabilities shipped |
| D13 | 14 Nov 2026 | Stacked PRs (each day builds on the previous one), merged in order | Each PR stays small enough to review | One giant PR (unreviewable). Independent PRs (would conflict in `ci.yml` and `controls.md`) |
| D14 | 14 Nov 2026 | Health data must stay in the UK: Conftest denies any AWS region except `eu-west-2`, and cross-region replication is skipped on purpose | Data residency matters more than a second-region backup for this scenario | Replicating to an EU region (possible under adequacy, but adds transfer questions for a small benefit) |
