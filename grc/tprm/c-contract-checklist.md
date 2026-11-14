# (c) Contract and assurance checklist

Clauses legal must check are in the contract **before signing**. ✔ = required for that tier.

| # | Clause | What it should say | T1 | T2 | T3 |
|---|---|---|---|---|---|
| C1 | **Security requirements** | The supplier meets a named baseline (Cyber Essentials Plus for T1, Cyber Essentials for T2) and keeps it current | ✔ | ✔ | |
| C2 | **Incident notification** | Notify MediPay within **24 hours** of becoming aware of an incident affecting our data or service (T1), or 72 hours (T2), with updates until closed | ✔ | ✔ | ✔ (72h) |
| C3 | **Data protection** | Article 28 UK GDPR processor terms where they process personal data, including how they report breaches to us 🔎 (ICO: breach reporting requirements *"should be detailed in the contract"* under Article 28) | ✔ | ✔ | |
| C4 | **Data location** | UK only, or named countries with a lawful transfer mechanism. No change without notice | ✔ | ✔ | |
| C5 | **Subcontractors** | Prior notice of new fourth parties handling our data. The same obligations flow down | ✔ | ✔ | |
| C6 | **Right to audit** | MediPay (or an auditor it appoints) may audit, or receive independent reports (SOC 2 or ISO) yearly | ✔ | | |
| C7 | **Vulnerability management** | Critical vulnerabilities fixed within an agreed SLA, with a report on request | ✔ | ✔ | |
| C8 | **Software supply chain** | SBOM per release, signed artefacts, and notice of security-relevant changes to the build process | ✔ (software suppliers) | | |
| C9 | **Access** | Least privilege, MFA, access removed within 24h when staff leave, logs of access to our data | ✔ | ✔ | |
| C10 | **Business continuity** | Tested BCP, with RTO and RPO stated. Test results shared yearly | ✔ | | |
| C11 | **Exit and data return** | On exit: our data returned in a usable format within 30 days, then deleted, with a deletion certificate. Reasonable help with transition | ✔ | ✔ | |
| C12 | **Termination for security** | MediPay may terminate if the supplier has a serious breach or repeatedly fails security obligations | ✔ | ✔ | |
| C13 | **Regulatory cooperation** | The supplier cooperates with MediPay's regulators and with obligations under the CS&R Bill if enacted and applicable. Exact wording waits for the secondary legislation 🔎 (GOV.UK summary: designation and reporting come via secondary legislation) | ✔ | | |

## Assurance (what we collect, how often)

| Tier | On signing | Yearly | On change |
|---|---|---|---|
| 1 | Full questionnaire (b), certificates, SOC 2 or ISO report, pen test summary | Re-attest, refresh certificates, review SOC 2 bridge letter | Material change (new hosting, acquisition, breach) means re-assess |
| 2 | Questionnaire Q1 to Q10, Cyber Essentials | Re-attest Q1 to Q10 | Re-assess if the data or access changes |
| 3 | Q1 to Q3 | Every 2 years | — |
