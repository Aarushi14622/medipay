# Three STAR interview stories

> About 2 minutes each. Practise them out loud and use the notes as prompts, not a script.

## 1. "Every scanner would have passed" (testing your own controls)

- **Situation:** My practice API for a fictional healthcare company rejects unknown fields in a request. That stops mass assignment, where someone sneaks in a field like `is_admin`. Several security scanners ran on every pull request.
- **Task:** I wanted to prove the protection really worked, not just that the code was there.
- **Action:** On a test branch I removed it. Bandit, Semgrep, pip-audit and Gitleaks would all have passed. Only the security test I'd written for this app failed: it got 201 Created instead of 422. After that I broke each early gate on purpose myself before trusting it: secrets scanning, Bandit, pip-audit and Semgrep. The newer gates (Kyverno, Conftest, ZAP) have tests built into CI that feed them bad input and expect a block.
- **Result:** I can point to evidence that each control fails when it should. In TPRM terms, when a supplier says "we run security scanning", my next question is "show me a build it blocked".

## 2. "The pipeline caught two real problems in one day" (continuous monitoring)

- **Situation:** On 14 Nov 2026 I was finishing the supply chain part of the project: pinned dependencies, an SBOM and signed images. An AI assistant (Claude) drafted the changes and I reviewed them.
- **Task:** Get the changes merged with every security gate green.
- **Action:** Two gates failed, and neither failure was caused by the change itself. **pip-audit** found a vulnerability published after the lockfile was built, in `opentelemetry-api`, a library FastAPI pulls in. **Trivy** blocked the merge because fixes had just come out for HIGH vulnerabilities in the base image. On Day 1 I'd recorded those as "accepted, no fix available". Claude proposed the fixes. I reviewed two things. First, that the new package version was over two weeks old, which is my rule for supplier updates. Second, the exception for the base image: a vendor's own security rebuild is younger than two weeks, and that's logged as decision D12.
- **Result:** Both were fixed the same day, with a written reason. It showed me that "accepted risk" has to be re-checked automatically. That's the case for continuous supplier monitoring instead of a yearly questionnaire.

## 3. "Due diligence a small team can actually run" (TPRM judgement)

- **Situation:** A fictional 250-person healthcare billing company with 10 key suppliers, a 3-person security team, and NHS customers asking about supply chain risk.
- **Task:** Put together a TPRM approach the team could realistically keep up.
- **Action:** I drafted it with AI help and reviewed it against what I'd learned in the labs. Suppliers are tiered on five things: data, access, impact, how replaceable they are, and whether a breach could spread to us. "Critical to us" is kept separate from being a "designated critical supplier", which under the Cyber Security and Resilience Bill would be the regulator's decision. Six suppliers came out as tier 1. One was a cheap IT support firm, because it has admin access to staff laptops. The questionnaire has 3, 10 or 22 questions depending on tier. For the software questions it says what a good and a weak answer look like, based on controls I'd seen working myself: SBOMs, signing, and short-lived cloud credentials instead of stored keys.
- **Result:** A tiered process, a one-page board brief with five measures, and a mapping to the UK Pledge and the Bill that says plainly what's still uncertain. Next I'd like to try the questionnaire on a real supplier to see which questions get vague answers.

---

**Short ones if asked:** a shallow git clone meant Gitleaks only scanned one commit (fixed with `fetch-depth: 0`). A 94 MB build context was sending `.git` to Docker (fixed with a deny-by-default `.dockerignore`). ZAP found missing headers, but only the threat model found that the API had no authentication.
