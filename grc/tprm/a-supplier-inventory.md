# (a) Supplier inventory and tiering

## Tiering criteria

A supplier's tier is set by its **highest** score on any one question. One "high" answer is enough to make it tier 1.

| Question | High (tier 1) | Medium (tier 2) | Low (tier 3) |
|---|---|---|---|
| **Data:** what MediPay data does it hold or see? | Patient or payment data | Staff or business-confidential data | None, or public only |
| **Access:** can it reach our systems? | Admin or privileged access, or code that runs in production | Standard user access or integration | None |
| **Impact:** what if it's down for a week? | Billing stops, or NHS customers are affected | Work slows, with workarounds | Barely noticed |
| **Substitutability:** how fast could we replace it? | More than 3 months, or no real alternative | 1 to 3 months | Under a month |
| **Vector:** could a compromise of it spread to us or our customers? | Yes, directly (code, credentials, integration) | Possibly | No |

**Internal tier ≠ legal designation.** Tier 1 means "critical to MediPay". Only a regulator can designate a "critical supplier" under the Bill ([phase1-context.md](../phase1-context.md)).

## Inventory (fictional relationships)

| # | Supplier | Service | Data | Access | Impact | Subst. | Vector | **Tier** | Owner |
|---|---|---|---|---|---|---|---|---|---|
| S1 | AWS (London) | Hosting for the Patients API and data | Patient | Runs production | High | High (>3 mo) | High | **1** | CTO |
| S2 | GitHub | Code, CI/CD, Dependabot, package registry | Code, no patient data | Code reaches production | High | Medium | **High** (pipeline compromise means compromised releases) | **1** | Head of Eng |
| S3 | "PayBridge Ltd" | Card payments | Payment | Integration | High | Medium | Medium | **1** | Finance Dir |
| S4 | "CodeRight Health" | Clinical coding SaaS | Patient | Integration | High | High (niche) | Medium | **1** | Ops Dir |
| S5 | "HelpDesk Partners" | Outsourced IT support | Staff, possibly patient via screens | **Admin** on laptops | Medium | Medium | **High** (an admin compromise reaches everything) | **1** | CISO |
| S6 | Microsoft 365 | Email, files, identity | Staff and patient (email) | Identity provider | High | High | High | **1** | CTO |
| S7 | Docker Hub and PyPI | Base images and packages | None | Code runs in production | Medium | Low | **High** | **1**\* | Head of Eng |
| S8 | "MailHouse UK" | Prints and posts invoices | Patient (name, address, amount) | File transfer | Medium | Low | Low | **1** (data) | Ops Dir |
| S9 | Security tool vendors (Trivy, Semgrep, ZAP, etc.) | Scanning in CI | Code | Runs in CI | Low | Low | Medium (the scanner is a supplier too, see the March 2026 Trivy incident) | **2** | CISO |
| S10 | Office cleaning company | Cleaning | None | Physical, out of hours | Low | Low | Low | **3** | Facilities |

\* **Open-source registries** can't be sent a questionnaire. They're managed by **technical controls** instead (pinning, hashes, SBOM, scanning, Dependabot review). This is where the technical labs *are* the TPRM control.

## Observations for the CISO

1. **Six of ten suppliers are tier 1.** That's normal for a small company in health data, but it means due diligence effort must be proportionate (b), or it won't happen.
2. **S5 HelpDesk Partners is the sleeper risk.** It looks like a low-value contract but has admin access. Example: the NCSC's APT10 advisory says the group targeted *"several global MSPs, giving it extensive access to the networks of organisations worldwide"* 🔎 ([NCSC, Dec 2018](https://www.ncsc.gov.uk/files/APT10%20advisory%20v2.pdf)). The Bill also brings medium and large MSPs into regulation 🔎 (GOV.UK summary, Nov 2026).
3. **Concentration:** S1 and S6 together hold nearly everything. If either has a regional outage, MediPay stops. See the exit options in (e).
