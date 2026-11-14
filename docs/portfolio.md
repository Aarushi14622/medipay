# Portfolio note

## What this is

A personal project to prepare for **technical GRC and TPRM analyst** roles in the UK. It is **not work experience**. The organisation (MediPay) is fictional, the data is synthetic, and every source is public.

The TPRM strand is written as if a CISO had asked for help as a consultant. Its working rules shaped the work: one question at a time, never invent facts, challenge weak thinking, keep a decision log, and write "as at [date]" next to regulatory statements.

## What to look at (10 minutes)

1. [Executive summary](executive-summary.md): the whole story in two pages.
2. [Supplier tiering](../grc/tprm/a-supplier-inventory.md) and the [tier 1 questions](../grc/tprm/b-due-diligence-questionnaire.md#tier-1-adds-q11-to-q22-software-and-supply-chain-depth): where the technical work feeds the TPRM work.
3. [Control cards](../grc/controls.md): each control with its risk, evidence and gaps.
4. [Threat model](threat-model.md): what scanners can't find.
5. [Decision log](../grc/decision-log.md): the trade-offs and what was rejected.

## How AI was used

I used Claude (Anthropic's AI assistant) throughout. Being specific about it matters, both for honesty and because "where did the AI get it wrong?" is a good interview question.

| Area | What AI did | What I did |
|---|---|---|
| Days 1–2 (early labs) | Explained concepts step by step. Gave commands and expected output | Ran every command on my own VM, interpreted results, broke each gate on purpose, wrote the control cards |
| Days 2–7 (finished on 14 Nov 2026) | **Drafted the code, CI jobs, policies and control cards** in reviewable PRs (#21 to #25), to get interview-ready quickly (decision D8) | Reviewed the PRs. Re-ran the "break it on purpose" tests myself for the gates up to Semgrep (lint and tests, secrets, Bandit, pip-audit, Semgrep). I haven't yet re-run the newer gates myself (image scan, SBOM, Kyverno, IaC, ZAP); their evidence is the CI runs |
| Phase 1 notes | Drafted summaries. Flagged unverified claims with ⚠️, then checked them against primary sources and quoted them (🔎, 14 Nov 2026) | Re-read the Pledge pack, the Bill's explanatory notes and the NCSC guidance myself. I haven't yet read the Synnovis sources myself; those points are Claude-checked (🔎) |
| TPRM deliverables (a)–(g) | Drafted the first versions | Reviewed; no changes yet. They're AI-drafted first versions |
| Executive summary and STAR stories | Drafted them in plain first-person language from my answers | Reviewed them. I practise the stories out loud rather than reciting them |

### Where AI was wrong, or needed correcting

- AI-written checks had bugs that **CI caught**: an SBOM check used text matching on minified JSON and failed, and the Trivy config scan flagged the deliberately broken policy test files. Both were fixed before merging. Lesson: AI-written code needs the same gates as human code.
- Scanner data can be wrong too. Trivy labelled a zlib CVE with a webpack description.

### What I'd say in an interview

"AI drafted a lot of this, and I say so. What I bring is that I know what each control does. I've broken the early gates myself, CI proves the newer ones block bad input, and I can tell a strong supplier answer from a weak one. The decision log and control cards show the reasoning, and the 🔎 and ⚠️ markers show what was checked against a source and what's still uncertain."
