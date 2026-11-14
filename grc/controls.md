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
