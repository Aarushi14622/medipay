# Three STAR interview stories

> Practise these out loud. Keep each to about 2 minutes. ✏️ Rewrite in your own words; an interviewer can tell when you're reciting.

## 1. "The check that passed while the bug shipped" (testing your own controls)

- **Situation:** My fictional company's patient API had mass-assignment protection: unknown fields in a request are rejected. Five generic security scanners ran on every PR.
- **Task:** Prove the protection was actually enforced, not just present in the code.
- **Action:** I removed the protection on a test branch. The generic scanners (Bandit, Semgrep, pip-audit, Gitleaks) **would all have passed**. Only the app-specific security regression test I'd added failed: it got 201 Created instead of 422. Since then I've broken every gate on purpose before trusting it, including removing the non-root user (image scan blocked the merge with DS-0002) and feeding Kyverno and Conftest broken manifests that CI must reject.
- **Result:** Every control in the repo has evidence that it fails when it should. **TPRM link:** when a supplier says "we run security scanning", I ask "show me a build it blocked". Generic scanning doesn't prove your specific risks are covered.

## 2. "Two real catches in one day" (continuous monitoring)

- **Situation:** On 14 Nov 2026 I was adding supply chain controls (hash pinning, SBOM, signing) to the pipeline.
- **Task:** Get the changes merged with every gate green.
- **Action:** Two gates failed for real reasons, not because of my change. **pip-audit** flagged a CVE published since my lockfile was built, in a library I'd never heard of (`opentelemetry-api`, pulled in by FastAPI). I checked that the fixed version was over two weeks old (my supplier rule) and bumped it. **Trivy** blocked the merge because fixes had just been released for HIGH vulnerabilities in the base image (apt, zlib), which I'd recorded as "accepted, no fix available" on Day 1. I moved to the rebuilt base image and patched zlib. I logged the exception to my two-week rule (D12): it protects against rushing new versions, not against applying a vendor's own security fixes.
- **Result:** Both fixed within hours, with an audit trail. It showed that "accepted risk" needs automatic re-checking, which is the argument for **continuous** supplier monitoring rather than yearly questionnaires.

## 3. "Designing proportionate due diligence" (TPRM judgement)

- **Situation:** A fictional 250-person healthcare billing company with 10 key suppliers, a 3-person security team, and NHS customers asking about supply chain risk.
- **Task:** Design a TPRM approach the team could actually run.
- **Action:** I tiered suppliers on five criteria: data, access, impact, substitutability and vector. I kept "critical to us" separate from "designated critical supplier", which under the CS&R Bill (not yet law) is the regulator's call. Six suppliers came out tier 1, including a low-cost IT support firm, because it had **admin access**. I wrote a questionnaire with 3, 10 or 22 questions by tier. For each tier 1 software question I wrote what a good and a weak answer look like, based on controls I'd built myself (SBOMs, signing, OIDC instead of stored keys).
- **Result:** A programme the team can run, a board brief with three asks and five measures, and a mapping to the Pledge and the Bill that states plainly what's uncertain. **What I'd do differently:** test the questionnaire on a real supplier to see which questions get vague answers.

---

**Also ready (one line each):** shallow clone hid secrets from Gitleaks (fixed with `fetch-depth: 0`), a 94 MB build context (deny-by-default `.dockerignore`), OIDC trust limited to one branch, and ZAP found headers but only the threat model found "no authentication".
