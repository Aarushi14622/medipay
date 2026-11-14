# (d) Continuous monitoring approach

Signing the contract is the start, not the end. Monitoring is **proportionate to tier**, and uses automation where we can.

## What we watch

| Signal | How | Tier | Frequency | Owner |
|---|---|---|---|---|
| **Certificate status** (Cyber Essentials, ISO) | Supplier Check Tool or certificate register lookup ⚠️ | 1, 2 | Quarterly (T1), yearly (T2) | GRC analyst |
| **Breach news and advisories** | NCSC Early Warning (Pledge action 2), news alerts on supplier names, vendor security advisories | 1 | Continuous | Security team |
| **Questionnaire refresh** | Re-attestation of (b) | 1, 2, 3 | Yearly, yearly, every 2 years | GRC analyst |
| **Contract obligations** | Did they notify incidents on time? Did they deliver the SOC 2 report? | 1 | Quarterly review | Supplier owner |
| **Open-source supply chain** | **Automated in CI** (see below) | S7 | Every PR and weekly | Head of Eng |
| **Access** | Review supplier accounts in M365, AWS and GitHub. Remove unused ones | 1 (S5 especially) | Quarterly | IT and the CISO |
| **Fourth parties** | Changes to their subcontractor list | 1 | On notice, plus yearly | GRC analyst |

## Our own pipeline is continuous monitoring for software suppliers

The technical labs already run supplier monitoring on every change:

| Pipeline control | What it monitors | Lab |
|---|---|---|
| Dependabot (pip, actions, docker) | New supplier versions, reviewed like a supplier change (publisher, release age ≥ 2 weeks, changelog, diff) | Day 1–2 |
| `pip-audit` | Known vulnerabilities in packages we already use. **It caught CVE-2026-126360 on 14 Nov 2026**, which wasn't known when the lockfile was built | Day 2 |
| Trivy `image-scan` | New fixes for base image CVEs. **It blocked a PR on 14 Nov 2026** when fixes for apt and zlib appeared | Day 1–2 |
| SBOM per build | Lets us answer "are we affected?" in minutes | Day 2 |
| Signature verification | Detects swapped or tampered images | Days 2–3 |

**Gap to close:** the pipeline only runs when someone opens a PR. A **scheduled weekly CI run** would catch new CVEs in quiet weeks. This is listed in the backlog.

## Triggers for an out-of-cycle review

- The supplier reports a breach, or one is reported in the news.
- The supplier is acquired, changes hosting location, or adds a fourth party.
- A certificate lapses.
- A missed incident notification SLA.
- MediPay starts sending the supplier more sensitive data.

## Measures (feed the board brief, f)

- % of tier 1 suppliers with a complete, in-date assessment.
- % of suppliers with a valid Cyber Essentials certificate (Pledge action 3).
- Number of overdue supplier remediation actions.
- Median days from a critical dependency CVE to a fix merged (pipeline data).
