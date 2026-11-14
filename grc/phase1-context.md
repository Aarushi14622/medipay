# Phase 1: UK context for supply chain risk

> **How to read this file.** Facts marked ✅ were read and checked by me against the original source (date shown). Facts marked ⚠️ **to verify** were drafted with AI help and **must be checked against the linked original before I repeat them in an interview**. Per the CISO's rules, nothing here is a substitute for the source.

## (a) UK Government Cyber Resilience Pledge

Source: `gov.uk/government/publications/cyber-resilience-pledge` and the information pack PDF linked from it. ✅ Pack dated April 2026, checked 21 Oct 2026.

| Action | What it asks (my words) | Supplier angle |
|---|---|---|
| 1. Board responsibility | Cyber is a **whole-Board** responsibility: adopt the Cyber Governance Code of Practice, and Board members complete NCSC Cyber Governance Training within 3 months, then yearly ✅ | The Board must understand supplier risk, not just IT |
| 2. Early warning | Sign up to the NCSC **Early Warning** service ✅ | Alerts can cover exposed services, including ones run by suppliers on your behalf ⚠️ to verify |
| 3. Suppliers | Use the **Supplier Check Tool**, audit Cyber Essentials coverage across the supply chain and report it to the Board, and take a risk-based approach to requiring Cyber Essentials ✅ | Directly shapes deliverables (a), (b) and (g) |

## (b) Cyber Security and Resilience (Network and Information Systems) Bill

Source: `bills.parliament.uk/bills/4035`. ✅ At **Lords report stage as at 21 Oct 2026, not yet law**. I read explanatory notes 329-EN (as introduced, Nov 2025). Later amendments and the June 2026 notes (Bill 002 EN 2026-27) are ⚠️ **not yet checked**.

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

⚠️ **Entire section to verify** against NHS England's and Synnovis's own statements before use. Record the date checked.

- Synnovis, a pathology services provider to NHS organisations in south east London, suffered a **ransomware attack in early June 2024** ⚠️.
- Hospital trusts that relied on it (reported as King's College Hospital and Guy's and St Thomas') had to postpone procedures and appointments, and blood testing was severely disrupted ⚠️.
- NHS Blood and Transplant appealed for O-type blood donors, because hospitals couldn't quickly match patients' blood types ⚠️.
- Data was later published by the attackers ⚠️.

**Why it matters for TPRM:** the hospitals' own systems weren't the entry point. A single supplier was **concentrated** (one provider for a whole area) and **hard to substitute**, which is exactly the "critical to us" test in deliverable (a). It's also the kind of supplier the Bill's designation powers are aimed at ⚠️ (check the Bill's own explanatory notes before claiming this link).

## Three things I didn't know (CISO's ask)

> **Draft candidates.** Pick three, confirm each against its source, and add the date checked. These are suggestions, not my findings yet.

1. **The regulator, not the customer, designates critical suppliers under the Bill.** I'd assumed each organisation decides who's critical to it. Source: Bill 329-EN ✅ (checked 21 Oct 2026).
2. **The Pledge puts cyber on the whole Board, with training deadlines.** It isn't only for the CISO, and Board members have a 3-month training window. Source: Pledge information pack ✅ (checked 21 Oct 2026).
3. **The NCSC isn't a regulator.** It gives guidance and runs services. NIS enforcement sits with sector regulators. Source: ⚠️ verify on ncsc.gov.uk ("About the NCSC").

## Sector decision

**Healthcare** (decision D10). It fits MediPay, it has a clear recent supply chain incident (Synnovis), health data is special category data under UK GDPR, and NHS suppliers are a realistic target for the Bill's supplier provisions ⚠️ (verify scope in the latest explanatory notes).
