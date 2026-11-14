## Container image scanning and non-root container (Day 1)

**Control:** Every pull request builds the container image and scans it with Trivy 0.70.0.
- Image scan: fails on HIGH/CRITICAL vulnerabilities that have a fix available.
- Dockerfile scan: fails on HIGH/CRITICAL misconfigurations (e.g. running as root).
- `image-scan` is a required check on `main`.
- Supporting controls: the app runs as a non-root user (UID 10001); the `.dockerignore` denies by default.

**Risk addressed:**
- Vulnerable operating system packages shipped without anyone noticing.
- A compromised app giving the attacker root inside the container.
- Git history or secrets ending up inside the image.

**Evidence:**
- PR #12 (merged): Dockerfile, .dockerignore, `image-scan` job.
- Test PR #13 (closed): USER line removed → DS-0002 (HIGH) → merge blocked.
- `whoami`: root → appuser. Build context: 94.34 MB → 11.78 kB.

**Accepted risk:** 44 HIGH findings (8 unique CVEs) in the Debian base image, none with a fix available, as at 24 Oct 2026. The gate blocks each one automatically once a fix exists.

**Known gap:** images pinned by tag, not digest (Day 2).

**Framework mapping:** to do (learner verifies).

**Interview line:** "I added image scanning as a required gate and hardened the container to run as non-root. Then I removed the fix on a test branch to prove the pipeline blocks it."

## Software supply chain: pinning, SBOM and signing (Day 2)

**Control:** Everything the pipeline pulls in is pinned to something that can't silently change, and every image that ships has an ingredients list and a signature.
- Container images pinned by **digest** (base image, Trivy, Semgrep, Gitleaks, Syft). Done in PR #15 for the base image and Trivy; this PR covers the rest.
- GitHub Actions pinned by **full commit SHA**, with the release in a comment (`@3d3c42e… # v7.0.1`).
- Python dependencies pinned by version **and hash** (`--require-hashes`) in both lockfiles and in the Dockerfile.
- Gitleaks in CI now runs from a pinned image instead of whatever version `apt` gives the runner.
- **SBOM:** Syft builds a CycloneDX and an SPDX SBOM of the image on every PR, kept as a CI artifact for 90 days.
- **Signing:** on `main` only, after every gate passes, the image is pushed to GHCR and signed with Cosign **keyless** (GitHub OIDC, no long-lived keys). The SBOM is attached as a signed attestation, and both are verified in the same job.
- Dependabot now also watches the Dockerfile base image.

**Risk addressed:**
- A tag (`@v7`, `:0.70.0`) being moved to malicious code by whoever controls it. This happened to Trivy's tags in March 2026 (see brief).
- A tampered package on PyPI with the same version number: the hash would not match, so the install fails.
- Not knowing what's inside an image when a new CVE lands ("are we affected?" needs an SBOM).
- An image being swapped in the registry: without a valid signature tied to this repo's workflow, it won't verify (and Day 3's Kyverno policy refuses to run it).

**Evidence:**
- PR #15 (merged): base image and Trivy by digest.
- This PR: CI run with all gates green and the `sbom` artifact attached.
- First push to `main` after merge: the `publish` job log shows "Signature and SBOM attestation verified".
- While writing this, `pip-audit` caught **CVE-2026-126360** in `opentelemetry-api 1.45.1` (a fastapi dependency) that wasn't known when the lockfile was made. It's bumped to 1.45.2, released 29 Oct 2026 and so over two weeks old as the supplier rule asks.
- On this PR's first CI run, the Day 1 `image-scan` gate **failed for real**. Fixes had been released for 4 HIGH findings in the base image: `apt` (CVE-2026-109518) and `zlib1g` (CVE-2026-85091 and CVE-2026-76844). It was fixed by moving the base image digest to the 8 Nov 2026 rebuild (which fixes apt) and upgrading `zlib1g` from Debian security until the base image catches up. Lesson: the "accepted, no fix yet" risk from Day 1 was handled automatically once fixes existed. Also, Trivy's title for CVE-2026-76844 describes a webpack bug, not zlib, so scanner data needs checking too.

**Known gaps:**
- Signing only happens on `main`, so PR builds are unsigned by design.
- SHA pins don't update themselves. Dependabot proposes the bumps, and each one is reviewed as a supplier change.
- The signature proves *who built it*, not that the code is safe. It only works together with the scanning gates.

**Framework mapping:** to do (learner verifies). Candidates: NCSC supply chain principles (understand what's in what you supply), the Pledge action 3 on suppliers, NIST SSDF PS.2 and PS.3.

**Interview line:** "I pinned every action, image and package so nothing can change under us. I made an SBOM for every build and signed images keylessly with Cosign. When I ask a supplier for an SBOM or signed releases, I know what a good answer looks like, because I've produced one."

## Kubernetes admission policies with Kyverno (Day 3)

**Control:** The cluster refuses pods that break our rules, and the rules are code reviewed in PRs (**Policy as Code**).
- `disallow-root`: pods must set `runAsNonRoot` and must not allow privilege escalation.
- `require-pinned-trusted-images`: images only from `ghcr.io/aarushi14622/`, only by digest.
- `verify-image-signature`: images must carry a Cosign signature from this repo's CI on `main`.
- Manifests follow least privilege: no service account token, no RBAC permissions, read-only filesystem, all capabilities dropped, default-deny NetworkPolicy.
- CI job `k8s-policy` proves each policy **passes good and fails bad** manifests on every PR.

**Risk addressed:**
- Someone deploys a root container or a random public image straight to the cluster and skips the pipeline.
- A compromised pod uses its API token or open network to move sideways (lateral movement).

**Evidence:**
- This PR's `k8s-policy` job: 8 policy tests pass, including 4 that **expect a block** (`bad-root`, `bad-image`).
- `kyverno apply` against `k8s/deployment.yaml`: pass 4, fail 0.

**Known gaps:**
- The signature policy isn't tested in CI because it needs the live registry. Test it in kind (`k8s/README.md`).
- No real cluster runs continuously. This is a local lab, not production.
- Kyverno's `ClusterPolicy` API is deprecated in favour of the newer CEL policy types. It still works in 1.19, but should be migrated later.

**Framework mapping:** to do (learner verifies). Candidates: CIS Kubernetes Benchmark (5.2 Pod Security, 5.3 Network Policies), NCSC cloud security principles (separation between users), least privilege.

**Interview line:** "The pipeline checks the image, and the cluster checks again. I wrote Kyverno policies that refuse root containers, untrusted registries and unsigned images, and CI proves each policy actually blocks a bad manifest."

## Infrastructure as Code scanning: Checkov and Conftest (Day 4)

**Control:** Cloud infrastructure is written as Terraform and scanned on every PR, before anything exists.
- `terraform fmt` and `validate` must pass.
- **Checkov** (general best practice) must report 0 failed checks. Every skipped check is written next to its resource with a reason.
- **Conftest** runs MediPay's own Rego rules: **London region only** (UK data residency), every bucket has a valid `data_classification`, public access fully blocked, no public ACLs. Each rule has a unit test.
- CI proves the gate works: a broken-on-purpose example (US region, unclassified bucket) **must** fail.
- First resource: an audit evidence bucket that is private, KMS-encrypted with key rotation, versioned, access-logged and HTTPS only.

**Risk addressed:**
- Misconfigured cloud storage (public buckets are a classic cause of health data leaks).
- Health data leaving the UK by accident.
- Unlabelled data that nobody knows how to protect.
- Evidence that can be quietly changed or deleted (versioning and access logs).

**Evidence:**
- This PR's `iac` job: Checkov 51 passed, 0 failed, 9 skipped with reasons. Conftest unit tests 7 of 7 passed. Conftest on our Terraform 20 of 20 passed. The bad example was blocked.

**Known gaps:**
- Nothing is deployed to real AWS (decision log). LocalStack is optional.
- `.terraform.lock.hcl` (the provider's "lockfile" with hashes) isn't committed yet. The cloud environment couldn't reach the Terraform registry. Run `terraform init` once on the VM and commit it, the same lesson as hash-pinning Python.
- Scanners only see code. Console changes (drift) need a different control, such as AWS Config or Prowler on a live account.

**Framework mapping:** to do (learner verifies). Candidates: CIS AWS Foundations (S3 sections), UK GDPR Article 32 (security of processing) and international transfer rules for the region policy, NCSC cloud security principle 2 (asset protection).

**Interview line:** "I scan infrastructure before it exists. Checkov covers general best practice, and I wrote our own rules in Rego, like 'London region only' and 'every bucket must be classified'. Every exception is written next to the resource with a reason, so a reviewer can challenge it."

## AWS account baseline as code: OIDC, CloudTrail, guard rails (Days 5 and 6)

**Control:** The AWS account baseline is written as Terraform and scanned in CI by Checkov, Conftest and Trivy. It is **not deployed** (decision D9).
- **GitHub OIDC:** CI gets short-lived credentials. The trust policy is limited to `repo:Aarushi14622/medipay:ref:refs/heads/main`. There are no stored access keys.
- **Least privilege:** the CI role can only upload to one S3 prefix.
- **CloudTrail:** multi-region, global events, KMS-encrypted, log file validation, HTTPS-only bucket, retained for 400 days.
- **Guard rails:** account-wide S3 public access block, default EBS encryption, a 14-character password policy, and a budget alert at 50% forecast and 100% actual.
- A runbook gives the safe order for a real account: root MFA, billing alert, no root keys, then apply, then Prowler, then destroy.

**Risk addressed:**
- Leaked long-lived cloud keys, one of the most common causes of cloud breaches.
- No audit trail after an incident. Tampered logs.
- Public data exposure through misconfiguration. Surprise costs.

**Evidence:**
- This PR's `iac` job: Checkov **131 passed, 0 failed**, 17 skipped with reasons (both Terraform folders). Conftest 45 of 45. Trivy config: 0 HIGH or CRITICAL.

**Known gaps:**
- Not applied, so there is no Prowler or CIS evidence from a live account. That is honest scope: "designed and scanned, not operated".
- The trail lives in the same account it audits. Real organisations use a separate log-archive account.
- No CloudWatch alerting on trail events (cost). Covered as a gap in the continuous monitoring approach.

**Framework mapping:** to do (learner verifies). Candidates: CIS AWS Foundations Benchmark (IAM, logging sections), NCSC Cloud Security Principles 9 to 10 (identity and authentication, operational security), Cyber Essentials (user access control, secure configuration).

**Interview line:** "My pipeline doesn't hold any cloud keys. It swaps a GitHub identity token for 1-hour AWS credentials, and only from the main branch of one repo. When a supplier tells me they 'store keys securely in CI', my next question is why they need stored keys at all."

## Dynamic testing (ZAP) and STRIDE threat model (Day 7)

**Control:** Every PR starts the real container and scans it with **OWASP ZAP's API scan**, driven by the app's OpenAPI description. Any warning or failure blocks the merge. A **STRIDE threat model** (`docs/threat-model.md`) covers the design flaws a scanner can't see.

**Risk addressed:**
- Runtime issues that code scanners miss, such as missing security headers or error pages that leak details.
- Design flaws: no authentication, guessable IDs, no per-user audit trail.

**Evidence:**
- First local ZAP run: **WARN-NEW: X-Content-Type-Options Header Missing [10021]**. 🛠️ The dev team fix is security headers middleware (`nosniff`, `Cache-Control: no-store`, `X-Frame-Options: DENY`, `Referrer-Policy: no-referrer`), plus a security regression test.
- Rerun: **0 FAIL, 0 WARN, 106 PASS**. This PR's `dast` job and its `zap-report` artifact.
- In CI, ZAP downloads newer rules and found two more warnings. **Spectre site isolation [90004]** was fixed with `Cross-Origin-Resource-Policy`, `-Opener-Policy` and `-Embedder-Policy` headers, plus a test. **ZAP is Out of Date [10116]** is ignored in `.zap/rules.tsv` with a reason, because we pin ZAP on purpose. Lesson: an unpinned rule set means the same scanner version can give different results on different days.
- Threat model: 3 open risks ranked, each with a planned fix.

**Known gaps:**
- ZAP runs without authentication, because the app has none. Once auth exists, the scan needs a logged-in context.
- The top three risks (auth, predictable IDs, audit log) are **open and accepted** for synthetic data only.

**Framework mapping:** to do (learner verifies). Candidates: OWASP ASVS (V14 configuration, V4 access control), OWASP API Security Top 10 (API1 broken object level authorisation, API2 broken authentication), NCSC secure development principles.

**Interview line:** "With my DAST background, I wired ZAP into CI as a merge gate. It found a missing header, and we fixed it with a regression test. Then my threat model found what ZAP couldn't: there's no authentication and IDs are guessable. Scanners find bug patterns, and threat models find design flaws. A supplier needs both."
