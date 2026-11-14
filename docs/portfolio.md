# Portfolio note

## What this is

A personal project to prepare for **technical GRC and TPRM analyst** roles in the UK. It is **not work experience**. The organisation (MediPay) is fictional, the data is synthetic, and every source is public.

The suggestion and the starting brief for the TPRM strand came from CISO Jitender Arora. His rules shaped the work: one question at a time, never invent facts, challenge weak thinking, keep a decision log, and write "as at [date]" next to regulatory statements.

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
| Days 2–7 (finished on 14 Nov 2026) | **Drafted the code, CI jobs, policies and control cards** in reviewable PRs (#21 to #25), to get interview-ready quickly (decision D8) | Reviewed and merged each PR, and re-ran the key "break it on purpose" checks myself. ✏️ *Update this line with what you actually re-ran* |
| Phase 1 notes | Drafted summaries. Flagged unverified claims with ⚠️ | Read the original Pledge pack, Bill notes and NCSC guidance myself (dates recorded). ✏️ *Record which ⚠️ items you verified* |
| TPRM deliverables (a)–(g) | Drafted the first versions | ✏️ *Record what you changed after review* |
| Executive summary, STAR stories, LinkedIn post | Drafted structure and wording | ✏️ *Rewrite in your own voice* |

### Where AI was wrong, or needed correcting

Examples from the project so far (✏️ add your own as you review):
- ✏️ *The Pledge "key corrections learned" in brief v4 (action 1 is whole-Board, action 2 is Early Warning, action 3 is suppliers). If an AI summary was what you corrected, say so here.*
- AI-written checks had bugs that **CI caught**: an SBOM check used text matching on minified JSON and failed, and the Trivy config scan flagged the deliberately broken policy test files. Both were fixed before merging. Lesson: AI-written code needs the same gates as human code.
- Scanner data can be wrong too. Trivy labelled a zlib CVE with a webpack description.

### What I'd say in an interview

"AI drafted a lot of this, and I say so. What I bring is that I know what each control does, I've seen each one fail, and I can tell a strong supplier answer from a weak one. The decision log and control cards show my reasoning, and the ⚠️ markers show where I still had to check a source."
