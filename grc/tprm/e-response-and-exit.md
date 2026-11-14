# (e) Supplier compromise response plan and exit options

## When a supplier is breached: the playbook

Built on the incident response lifecycle (prepare, detect, contain, eradicate, recover, learn), adapted for a breach that's **someone else's**, where we don't control the investigation.

| Phase | Actions | Who | Timing |
|---|---|---|---|
| **1. Detect and confirm** | Supplier notice, NCSC alert, news or our own monitoring. Confirm with the supplier's named contact (C2). Open an incident ticket | Security on call | Hour 0 |
| **2. Scope** | Which data does this supplier hold (a)? What access does it have? Use the **SBOM** for software suppliers: are we running the affected component? | Security and supplier owner | Hours 0–4 |
| **3. Contain** | Revoke or rotate credentials and API keys shared with the supplier. Suspend their access (S5: disable admin accounts). Block integrations if needed. For a compromised package or image: pin to the last known good digest, and the **signature verification** will refuse unsigned replacements | Security and Eng | Hours 0–8 |
| **4. Notify** | Is it a personal data breach? Assess the ICO 72-hour duty ⚠️ verify. Tell NHS customers as their contracts require. Brief the Board | DPO, CISO, legal | Within 72h |
| **5. Continue service** | Activate fallback (see the exit options). Manual processes if needed | Ops | As needed |
| **6. Recover** | Restore access only after the supplier shows root cause and fix. Re-run due diligence (b) Q11 to Q18 | Security and supplier owner | Days–weeks |
| **7. Learn** | Post-incident review. Update the tier, contract, monitoring and decision log | CISO | Within 30 days |

## Exit options for tier 1 suppliers

| Supplier | Fallback if it fails | Exit route | Time to exit | Readiness |
|---|---|---|---|---|
| S1 AWS | Container image runs anywhere (Kubernetes manifests, Day 3). Data restore from backup | Another UK cloud region or provider. Terraform needs re-writing for a new provider | 3–6 months | 🟠 Portable app, non-portable infrastructure |
| S2 GitHub | Local git clones are complete copies. CI definitions are readable YAML | GitLab or similar. Re-create pipelines | 1–2 months | 🟢 Low lock-in |
| S3 PayBridge | Manual invoicing by bank transfer | Second payment processor pre-contracted | 1 month | 🟠 No second processor yet |
| S4 CodeRight | Manual coding by staff (slow) | Alternative coding vendor, but a niche market | 3+ months | 🔴 **Highest substitution risk.** Recommend identifying an alternative now |
| S5 HelpDesk | Internal IT covers critical issues | Re-tender | 1–2 months | 🟢 |
| S6 Microsoft 365 | Phone and personal email for emergencies (no patient data) | Not realistic short term | 6+ months | 🔴 Accept, and focus on resilience instead |

## Tabletop exercise (60 minutes)

**Scenario:** At 09:00 on a Monday, "CodeRight Health" (S4) emails that it has suffered ransomware. Its service is offline, and it "can't rule out" that patient data was taken. Three NHS trusts call asking whether their patients are affected.

**Injects:**
1. (+30 min) A criminal group posts a sample of data claimed to be from CodeRight.
2. (+2 hours) The NHS trusts' contracts need notice within 24h. Do we notify before CodeRight confirms?
3. (+1 day) CodeRight says it'll be offline for 2 weeks. Month-end billing is in 5 days.

**Questions:** Who leads? What do we tell the trusts and when? Is this our personal data breach, and when does the ICO clock start? ⚠️ What's the manual fallback, and does it scale? What would we change in (a) to (d)?

**Success looks like:** decisions logged with times, a holding statement to the trusts within 4 hours, a clear owner for the ICO assessment, and at least three actions fed back into the TPRM process.
