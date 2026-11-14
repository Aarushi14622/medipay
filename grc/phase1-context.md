# Phase 1: UK context for supply chain risk

> **How to read this file.** ✅ = I read and checked it against the original source myself (date shown). 🔎 = Claude checked it against the original source on 14 Nov 2026 and quoted the source; **I still re-read the link before using it in an interview** (CISO rule: the learner verifies). ⚠️ = still uncertain.

## (a) UK Government Cyber Resilience Pledge

Source: `gov.uk/government/publications/cyber-resilience-pledge` and the information pack PDF linked from it. ✅ Pack dated April 2026, checked 21 Oct 2026.

| Action | What it asks (my words) | Supplier angle |
|---|---|---|
| 1. Board responsibility | Cyber is a **whole-Board** responsibility: adopt the Cyber Governance Code of Practice, and Board members complete NCSC Cyber Governance Training within 3 months, then yearly ✅ | The Board must understand supplier risk, not just IT |
| 2. Early warning | Sign up to the NCSC **Early Warning** service ✅ | Alerts are tailored to the public IP addresses and domains you register: incident notifications, network abuse events, vulnerability and open port alerts. The NCSC's own case study shows a critical infrastructure owner encouraging **its suppliers** to sign up, and the NCSC then alerting one of them to a web shell 🔎 ([NCSC Early Warning](https://www.ncsc.gov.uk/section/active-cyber-defence/early-warning)) |
| 3. Suppliers | Use the **Supplier Check Tool**, audit Cyber Essentials coverage across the supply chain and report it to the Board, and take a risk-based approach to requiring Cyber Essentials ✅ | Directly shapes deliverables (a), (b) and (g) |

## (b) Cyber Security and Resilience (Network and Information Systems) Bill

Source: `bills.parliament.uk/bills/4035`. ✅ At **Lords report stage as at 21 Oct 2026, not yet law**. I read explanatory notes 329-EN (as introduced, Nov 2025). Later amendments and the June 2026 notes (Bill 002 EN 2026-27) are not yet read.

🔎 **Status check, 14 Nov 2026:** Claude couldn't confirm a stage later than 21 Oct from the official bill page. Search results include a Parliament news item titled "Lords completes examination of Cyber Security and Resilience Bill" (October 2026), but the page wouldn't load to confirm it. ⚠️ Check [bills.parliament.uk/bills/4035](https://bills.parliament.uk/bills/4035) for the current stage and whether it has had Royal Assent before saying "not yet law" in an interview.

🔎 The GOV.UK [Summary of the Bill](https://www.gov.uk/government/publications/cyber-security-and-resilience-network-and-information-systems-bill-factsheets/summary-of-the-bill) (updated 3 Nov 2026) says: regulators will be able to designate critical suppliers; medium and large managed service providers come into scope (regulated by the Information Commission); incident reporting with *"initial notification within 24 hours and a fuller report within 72 hours"*; and several of these come **via secondary legislation**. It lists *"Health – including NHS trusts, integrated care boards and independent providers"* as an existing essential services sector.

Key points from the notes as introduced ✅:
- The **regulator** designates critical suppliers, not the customer.
- An operator of essential services (OES) can't also be designated a critical supplier for the same service.
- Designation can be revoked. The regulator considers alternatives (substitutability). Vector risk counts.
- Critical suppliers' actual duties come in **later regulations**, so they are still to be decided.

**Keep separate:** "legally designated critical supplier" (the regulator's decision under the Bill) vs "critical to us" (our own internal tiering in deliverable (a)).

## (c) NCSC supply chain security guidance

Source: `ncsc.gov.uk/collection/supply-chain-security`. ✅ Published 28 Jan 2018, reviewed 22 Oct 2025, v1.0. Checked 24 Oct 2026.
- 12 principles in 4 stages ✅: understand the risks, establish control, check your arrangements, continuous improvement.
- Not written for high-assurance or national security organisations ✅.
- The "Assessing" pages are saved for deliverable (b).

## (d) A public UK incident: Synnovis (June 2024)

All points 🔎 checked against NHS England, NHS Blood and Transplant and NHS England statements on 14 Nov 2026.

- Synnovis, *"a pathology partnership between SYNLAB, Guy's and St Thomas' NHS Foundation Trust and King's College Hospitals NHS Trust"*, *"was hit by a ransomware cyber-attack on Monday 3 June 2024"* 🔎 ([NHS England London](https://www.england.nhs.uk/london/synnovis-ransomware-cyber-attack/)).
- It affected services at Guy's and St Thomas' and King's College Hospital, and primary care in south east London. *"Some activity has already been cancelled or redirected to other providers"*, while emergency care continued 🔎 ([NHS London statement, 4 June 2024](https://www.england.nhs.uk/london/2024/06/04/nhs-london-statement-on-synnovis-ransomware-cyber-attack/)).
- On 10 June 2024 NHS Blood and Transplant asked O positive and O negative donors to book urgently, because affected hospitals *"cannot currently match patients' blood at the same frequency as usual"* 🔎 ([NHSBT](https://www.nhsbt.nhs.uk/news/o-positive-and-o-negative-donors-asked-to-urgently-book-appointments-to-give-blood-following-london-hospitals-it-incident/)).
- Synnovis confirmed that *"the data published by a cyber crime group has been stolen from some of their systems"* 🔎 ([NHS England, 24 June 2024](https://www.england.nhs.uk/2024/06/synnovis-cyber-attack-statement-from-nhs-england-24-june/)).

**Why it matters for TPRM:** the hospitals' own systems weren't the entry point. A single supplier was **concentrated** (one provider for a whole area) and **hard to substitute**, which is exactly the "critical to us" test in deliverable (a). The Bill's critical supplier power is meant to cover *"the most important suppliers to essential and digital services"* 🔎 (GOV.UK summary). That's my reading of how Synnovis fits, not a government statement about Synnovis.

## Three things I didn't know (CISO's ask)

> Pick the three that genuinely surprised you, and say them in your own words.

1. **The regulator, not the customer, designates critical suppliers under the Bill.** I'd assumed each organisation decides who's critical to it. Source: Bill 329-EN ✅ (checked 21 Oct 2026).
2. **The Pledge puts cyber on the whole Board, with training deadlines.** It isn't only for the CISO, and Board members have a 3-month training window. Source: Pledge information pack ✅ (checked 21 Oct 2026).
3. **The NCSC isn't a regulator.** It gives guidance and runs services. NIS enforcement sits with sector regulators. Source: NCSC Board Toolkit says *"The NCSC is **not** a regulator"* and *"The regulatory responsibilities are carried out by Competent Authorities"* 🔎 ([NCSC](https://www.ncsc.gov.uk/collection/board-toolkit/principle-b-strategy/cyber-security-regulation-and-directors-duties-in-the-uk), v3.0, reviewed 8 Apr 2025).

## Sector decision

**Healthcare** (decision D10). It fits MediPay, it has a clear recent supply chain incident (Synnovis), health data is special category data under UK GDPR, and health (NHS trusts, ICBs, independent providers) is an essential services sector under NIS 🔎 (GOV.UK summary), so its suppliers are in the Bill's sights.
