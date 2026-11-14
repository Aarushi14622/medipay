# Executive summary: MediPay supply chain security

**As at 14 Nov 2026.** A personal portfolio project about a fictional company. Regulatory statements are only as current as the date shown. Sources are linked in the detailed documents.

## The problem

MediPay (fictional) processes billing for 12 NHS trusts and about 40 private clinics, using special category health data. It depends on 10 key suppliers, and **six are critical to it**. NHS trusts in turn depend on MediPay. The 2024 Synnovis attack showed what happens when a single, hard-to-replace healthcare supplier is breached (sources in [phase1-context.md](../grc/phase1-context.md)).

At the same time, UK expectations are rising:
- The **Cyber Resilience Pledge** asks organisations to make cyber a whole-Board responsibility, sign up to NCSC Early Warning, and audit Cyber Essentials coverage across their suppliers (information pack, April 2026).
- The **Cyber Security and Resilience Bill** would let regulators designate critical suppliers. It is **not yet law** (Lords report stage as at 21 Oct 2026), and supplier duties will come in later regulations.

## What was built

### 1. A TPRM programme sized for a 250-person company

| Deliverable | Key point |
|---|---|
| [Inventory and tiering](../grc/tprm/a-supplier-inventory.md) | Five criteria (data, access, impact, substitutability, vector). "Critical to us" is kept separate from "legally designated" |
| [Questionnaire](../grc/tprm/b-due-diligence-questionnaire.md) | 3, 10 or 22 questions by tier, each with what a good and a weak answer looks like |
| [Contract checklist](../grc/tprm/c-contract-checklist.md) | 24-hour breach notice, UK data location, SBOM and signed releases for software suppliers, exit and data return |
| [Monitoring](../grc/tprm/d-continuous-monitoring.md) | Proportionate by tier. The CI pipeline acts as automated monitoring for open-source suppliers |
| [Response and exit](../grc/tprm/e-response-and-exit.md) | A 7-phase playbook for a breach at a supplier, exit options for each critical supplier, and a tabletop exercise |
| [Board brief](../grc/tprm/f-board-brief.md) | Top three risks and five quarterly measures |
| [Mapping](../grc/tprm/g-mapping.md) | Coverage of the Pledge and the Bill, with uncertainty stated plainly |

### 2. Technical controls that show what "good" looks like

The same controls the questionnaire asks suppliers about, built and tested on a small API:

- **Software supply chain:** every dependency, action and image is pinned (hash, SHA, digest). Each build has an SBOM. Releases are signed with Cosign keyless.
- **Policy as code:** Kubernetes refuses root, untrusted or unsigned images (Kyverno). Terraform must keep data in London and classify every bucket (Conftest).
- **Scanning gates that block:** secrets, SAST, SCA, image, IaC and DAST. **Each one was seen to fail on purpose before it was trusted.**
- **No stored cloud keys:** CI uses short-lived OIDC credentials, limited to one branch.

## What the work showed

1. **Controls caught real issues on the same day.** pip-audit found a newly published CVE in a dependency, and the image scan blocked a merge as soon as fixes for base image vulnerabilities were released. Both were fixed within hours. Continuous monitoring works when it's automated.
2. **Scanners find bug patterns, and threat models find design flaws.** ZAP found missing headers. Only the threat model found the biggest risks: no authentication and guessable record IDs.
3. **Open-source suppliers can't be sent a questionnaire.** For them, technical controls *are* the TPRM process.
4. **Proportion matters.** Six of ten suppliers being tier 1 is normal for health data. Without tiered questionnaires, due diligence wouldn't happen at all.

## Top recommendations for the (fictional) Board

1. Pre-qualify an alternative clinical coding supplier, the highest substitution risk.
2. Replace the IT support provider's standing admin access with time-limited, monitored access.
3. Fund and test a continuity plan for cloud and Microsoft 365 concentration.
4. Fix the API's top risks (authentication, random IDs, per-user audit log) before any real data is used.

## Honest limits

This is a lab. Nothing was deployed to a real AWS account. The TPRM documents haven't been tested on real suppliers. Parts were drafted with AI and reviewed by me. See [the portfolio note](portfolio.md#how-ai-was-used).
