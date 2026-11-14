# (b) Tiered due diligence questionnaire

**Proportionate:** tier 3 answers 3 questions, tier 2 answers 10, tier 1 answers all of them, with evidence. Asking a cleaning company for a SOC 2 report wastes everyone's time and gets ignored.

Each question says **why we ask** and **what a good answer looks like**, so a reviewer can tell a strong answer from a weak one.

## All tiers (3 questions)

| # | Question | Good answer |
|---|---|---|
| Q1 | Do you hold **Cyber Essentials** or Cyber Essentials Plus? Give the certificate number | A valid certificate we can check with the Supplier Check Tool or the IASME register ⚠️ verify the lookup route |
| Q2 | Who do we contact about a security incident, and how fast will you tell us? | A named role and a 24/7 route, with a notice time in hours, not "promptly" |
| Q3 | Will any MediPay data leave the UK? | "No", or a named country with a lawful transfer mechanism |

## Tier 2 adds (Q4 to Q10)

| # | Question | Good answer |
|---|---|---|
| Q4 | How do your staff log in to systems that hold our data? | MFA for everyone. Phishing-resistant MFA for admins |
| Q5 | How quickly do you patch critical vulnerabilities? | A defined SLA (e.g. 14 days for critical), and they can show it's measured |
| Q6 | Is our data encrypted at rest and in transit? | Yes, with named standards (TLS 1.2+, AES-256) |
| Q7 | Who in your company can access our data? | A short, named list of roles, with access reviewed regularly |
| Q8 | Do you use subcontractors (fourth parties) for our service? Which ones? | A list, and they flow our requirements down to them |
| Q9 | When was your last independent test (pen test or audit)? | Within 12 months, with a summary available |
| Q10 | Do you have an incident response plan, and when was it last exercised? | Yes, exercised in the last year |

## Tier 1 adds (Q11 to Q22): software and supply chain depth

These are the questions the technical labs taught me to ask.

| # | Question | Why we ask | Good answer | Weak answer |
|---|---|---|---|---|
| Q11 | Can you provide an **SBOM** (CycloneDX or SPDX) for what you deliver to us? | When the next big library CVE lands, we need to know in hours whether you're affected | Yes, machine-readable, per release (like Day 2's Syft output) | "We track our dependencies" with no artefact |
| Q12 | Are your releases or images **signed**, and how can we verify them? | Proves what we run came from you, unmodified | Cosign or Sigstore or similar, with verification instructions (like Day 2) | "Downloaded from our website over HTTPS" |
| Q13 | How do you pin dependencies and build tools? | Tags can be moved, as in the March 2026 Trivy incident | Versions **and hashes**, actions pinned by SHA, images by digest | "We use the latest versions" |
| Q14 | What security checks block a release? | Scanning that reports but never blocks isn't a control | Named gates (SAST, SCA, secrets, image scan) that **fail the build**, and they can show a blocked example | "We run scans" |
| Q15 | How do your pipelines get cloud credentials? | Stored long-lived keys are a top breach cause | Short-lived via OIDC, scoped to a branch (like Days 5 and 6) | Access keys in CI secrets |
| Q16 | How do you stop production running unapproved or root containers? | Pipeline checks can be bypassed | Admission policy (Kyverno or OPA) enforcing non-root and signed images (like Day 3) | "Our engineers know not to" |
| Q17 | Is your infrastructure defined as code and scanned before deployment? | Misconfiguration is the most common cloud failure | Terraform plus Checkov or a similar gate, with exceptions documented next to the code (like Day 4) | Manual console changes |
| Q18 | Do you perform DAST and threat modelling? What was the last top risk you found? | A specific answer shows it's real | A named recent finding and its fix (like Day 7) | "No significant issues found" |
| Q19 | Provide your SOC 2 Type II or ISO 27001 certificate and Statement of Applicability | Independent assurance | Current, scope covers **our** service | Scope excludes the service we buy |
| Q20 | Where is your audit logging, how long is it kept, and can you tell us who accessed our data? | We need per-user traceability for health data | Per-user logs kept 12+ months, available on request | IP addresses only (our own gap, see the threat model) |
| Q21 | What's your business continuity plan for our service? RTO and RPO? | Availability is part of security | Tested plan, RTO and RPO in hours | Untested, or "we're on AWS so it's fine" |
| Q22 | How do you handle **your** critical suppliers? | Fourth-party risk (Synnovis-style concentration) | Their own tiering and due diligence process | None |

## Scoring

| Result | Meaning | Action |
|---|---|---|
| All good answers | Low residual risk | Approve |
| Weak answers with a plan and a date | Moderate | Approve with conditions written into the contract (c) |
| Weak answers on Q2, Q3, Q4 or Q11 to Q15 for tier 1, no plan | High | Escalate to the CISO. Risk acceptance by the business owner, or don't sign |
