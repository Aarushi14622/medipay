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
