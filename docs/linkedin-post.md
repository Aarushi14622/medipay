# LinkedIn post (draft)

> ✏️ **Rewrite this in your own voice before posting.** The CISO asked for it to be yours, and to include where AI helped and where you corrected it. Check every claim against the repo. Add the repo link.

---

For the last few weeks I've been working on a personal project to prepare for third-party and supply chain risk roles. It came from a suggestion by Jitender Arora.

The idea: I'd understand supplier security better if I built the controls I'd be asking suppliers about.

So I built a small (fictional) healthcare billing API and put it through 10 security gates in CI: secrets scanning, SAST, dependency checks, container scanning, Kubernetes and Terraform policies, and an OWASP ZAP scan. Then I wrote the TPRM side: supplier tiering, a proportionate questionnaire, contract clauses, a breach response and exit plan, and a one-page board brief mapped to the UK Cyber Resilience Pledge and the Cyber Security and Resilience Bill.

What surprised me:

🔹 **A check you've never seen fail is a check you can't trust.** When I removed a security control, every generic scanner would have passed. Only a test written for that specific app caught it.

🔹 **"Accepted risk" doesn't stay accepted.** Vulnerabilities I'd recorded as "no fix available" got fixes, and my pipeline blocked the merge the same day. That's the case for continuous monitoring over yearly questionnaires.

🔹 **Scanners find bugs, and threat models find design flaws.** ZAP found missing headers. Only the threat model found that the API had no authentication at all.

🔹 **You can't send PyPI a questionnaire.** For open-source suppliers, pinning, SBOMs and signing *are* the due diligence.

On AI: I used Claude throughout, to explain concepts and to draft code and documents. I had to correct it, for example [✏️ your example], and CI caught bugs in AI-written checks. [✏️ Keep only once true:] Every regulatory claim was checked against the original source, with the date recorded.

[repo link]

#GRC #TPRM #SupplyChainSecurity #CyberSecurity #UKCyber
