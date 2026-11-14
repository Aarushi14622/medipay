# Threat model: MediPay Patients service (STRIDE)

**As at 14 Nov 2026.** Scope: the Patients API (`app/main.py`), its container, the CI pipeline and the planned Kubernetes and AWS setup. Synthetic data only.

## What we're protecting

| Asset | Why it matters |
|---|---|
| Patient records (name, date of birth, member ID) | Special category health data under UK GDPR. A leak harms patients and the organisation |
| The container image | If it's tampered with, everything running it is compromised |
| The CI pipeline and its tokens | Whoever controls the pipeline controls what ships |
| Audit evidence (SBOMs, scan reports, CloudTrail) | Needed to prove what happened, to us and to regulators |

## Data flow (plain words)

```
User/client ──HTTP──▶ Patients API (container, UID 10001) ──▶ in-memory store
                              ▲
Developer ──PR──▶ GitHub ──CI gates──▶ GHCR (signed image) ──Kyverno checks──▶ Kubernetes
```

Trust boundaries: (1) the internet to the API; (2) a developer's PR to `main`; (3) the registry to the cluster.

## STRIDE

| | Threat | Example against MediPay | Control in place | Status |
|---|---|---|---|---|
| **S**poofing | Pretending to be someone else | Anyone calls `GET /patients/1`. **There is no authentication** | None yet | 🔴 **Open:** top risk. Needs auth (OAuth2/OIDC) before any real data |
| | | A fake image pretends to be ours | Cosign keyless signing (Day 2) and Kyverno signature policy (Day 3) | 🟢 |
| **T**ampering | Changing data or code | Malicious package version on PyPI | Hash-pinned dependencies (Day 2), pip-audit, Dependabot review | 🟢 |
| | | A moved action or image tag | SHA and digest pinning (Day 2) | 🟢 |
| | | Extra fields slipped into a record (mass assignment) | `extra="forbid"` and a regression test | 🟢 |
| | | Container modifies its own code | Code root-owned, non-root user, read-only root filesystem in Kubernetes | 🟢 |
| **R**epudiation | "It wasn't me" | Who read patient 42's record? Logs show an IP only | Uvicorn access logs (IP, path) | 🟠 **Gap:** no user identity in logs (depends on auth) |
| | | Who changed the AWS account? | CloudTrail with log file validation (Days 5 and 6, designed) | 🟡 Designed, not deployed |
| **I**nformation disclosure | Data leaks | ID enumeration: `GET /patients/1`, `/2`, `/3`... | Generic 404, server-assigned IDs | 🔴 **Open:** sequential IDs and no auth make enumeration trivial. Use random IDs (UUIDs) and auth |
| | | Responses cached by a proxy or browser | `Cache-Control: no-store` (added after the ZAP scan, Day 7) | 🟢 |
| | | Secrets committed to git | Gitleaks pre-commit and CI | 🟢 |
| | | Public S3 bucket | Checkov, Conftest, account public access block | 🟢 |
| **D**enial of service | Making it unavailable | Flooding `POST /patients` fills memory (in-memory store) | Kubernetes memory limit (256Mi) restarts the pod. No rate limiting | 🟠 **Gap:** add rate limiting at the ingress or gateway |
| **E**levation of privilege | Getting more rights | Code execution in the app leads to root in the container | Non-root UID 10001, capabilities dropped, no privilege escalation, Kyverno enforces it | 🟢 |
| | | Pod uses its Kubernetes API token | Token not mounted, service account has no RBAC | 🟢 |
| | | Pipeline credentials abused | Workflow `permissions: contents: read`. Write and OIDC only in `publish`. No stored cloud keys | 🟢 |

## Top three risks to act on (in order)

1. **No authentication** (Spoofing and Information disclosure). Anyone who can reach the API can read every record. Accepted only because the data is synthetic and nothing is exposed publicly.
2. **Predictable IDs** (Information disclosure). Even with auth, sequential IDs invite IDOR bugs. Use UUIDs and check each record belongs to the caller.
3. **No per-user audit log** (Repudiation). Health data access needs to be traceable to a person. Depends on (1).

## What the DAST scan did and didn't tell us

ZAP's API scan (Day 7) found one real issue: the `X-Content-Type-Options` header was missing. It was fixed with security headers middleware and a regression test. Then ZAP reported **0 warnings, 0 failures, 106 passes**.

ZAP **could not** find the top three risks above. A scanner doesn't know that patient 1's record shouldn't be readable by everyone. That's why the threat model exists: scanners find *known bug patterns*, while threat modelling finds *design flaws*.
