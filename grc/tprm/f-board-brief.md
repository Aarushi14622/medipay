# (f) Board brief: supply chain risk (one page)

**To:** MediPay Board · **From:** CISO · **As at:** 14 Nov 2026 · **Classification:** Internal (fictional)

## The point

MediPay depends on **10 key suppliers. Six are tier 1:** if any one of them is breached or fails, patient data or billing is directly at risk. NHS customers depend on us in the same way, and they will ask us the questions we should be asking our suppliers. The 2024 Synnovis attack showed how one supplier's breach can disrupt patient care across a whole area: operations were cancelled across south east London, and NHS Blood and Transplant appealed for O-type donors ([NHS England](https://www.england.nhs.uk/london/synnovis-ransomware-cyber-attack/), [NHSBT](https://www.nhsbt.nhs.uk/news/o-positive-and-o-negative-donors-asked-to-urgently-book-appointments-to-give-blood-following-london-hospitals-it-incident/)).

## What we've done

- **Inventory and tiering** of all key suppliers, on five criteria (data, access, impact, substitutability, vector).
- **Proportionate due diligence:** 3 questions for low-risk suppliers, 22 with evidence for tier 1.
- **Contract standard:** 24-hour breach notice, UK data location, right to audit, and an exit plan for tier 1.
- **Our own software supply chain is controlled in code:** every component is pinned, scanned, listed in an SBOM and signed, and policies block unapproved images. These controls caught two real issues in one day (14 Nov 2026).

## Top three risks

| Risk | Why | Ask of the Board |
|---|---|---|
| 1. **CodeRight Health (clinical coding)** has no real alternative | If it fails, billing stalls for months | Approve work to identify and pre-qualify a second supplier |
| 2. **HelpDesk Partners has admin access** to staff laptops | A breach of them is a breach of us | Approve a move to time-limited, monitored admin access |
| 3. **Concentration on AWS and Microsoft 365** | A major outage stops MediPay | Accept the risk, and fund a tested continuity plan |

## Five measures we'll report quarterly

| Measure | Target | Today |
|---|---|---|
| Tier 1 suppliers with an in-date assessment | 100% | 0 of 6 (process just launched) |
| Suppliers with valid Cyber Essentials (Pledge action 3) | 100% of T1–T2 | Not yet audited |
| Overdue supplier remediation actions | 0 | n/a |
| Tier 1 suppliers with a tested exit or fallback plan | 100% | 2 of 6 (GitHub, HelpDesk) |
| Median days from a critical dependency CVE to a fix in our code | ≤ 7 | Same day (14 Nov 2026 example) |

## Regulatory note

The Cyber Security and Resilience Bill is **not yet law** (Lords report stage as at 21 Oct 2026). Under it, regulators, not MediPay, would designate critical suppliers. We are unlikely to be designated, but we are preparing as if we could be (decision D11). The Board's Pledge commitments (whole-Board responsibility, Early Warning, supplier Cyber Essentials audit) are covered by this programme. See the mapping (g).

**Decision needed today:** approve risks 1 and 2 actions. Note risk 3.
