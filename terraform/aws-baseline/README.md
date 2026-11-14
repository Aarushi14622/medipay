# AWS baseline (Days 5 and 6), scanned only

**Decision (D9):** no real AWS account is created in this project. It costs money, and it needs a personal sign-up. This folder is the baseline as code, and CI scans it like everything else. If you ever apply it, follow the order below.

## What's in it

| File | Control | Risk it addresses |
|---|---|---|
| `github-oidc.tf` | GitHub Actions gets **short-lived** AWS credentials via OIDC. The trust policy allows **only this repo's `main` branch** | Long-lived access keys stored in GitHub and leaked. Forks or PR branches assuming the role |
| `github-oidc.tf` | CI role can only `s3:PutObject` to `medipay-audit-evidence-lab/ci/*` | A compromised pipeline doing anything else in the account |
| `cloudtrail.tf` | Multi-region CloudTrail, KMS-encrypted, **log file validation** on, bucket HTTPS only | No audit trail after an incident. Attacker activity in an unused region. Tampered logs |
| `account.tf` | Account-wide S3 public access block, EBS encryption by default, strong password policy | Public buckets. Unencrypted disks. Weak console passwords |
| `account.tf` | **Budget alert** at 50% forecast and 100% actual | Surprise bills (e.g. leaked keys used for crypto mining) |

## If you apply it on a real account: do it in this order

1. Create the account, then **turn on MFA for the root user** immediately.
2. Set up a **billing alert** by hand in the console before anything else. Don't wait for Terraform.
3. Never create root access keys. Make an admin user (IAM Identity Center) with MFA and use that.
4. `terraform init && terraform plan`. Read the plan, then `apply`.
5. Run **Prowler** against CIS: `prowler aws --compliance cis_4.0_aws`. Note the findings (that's the Day 6 evidence).
6. `terraform destroy` when finished, and check the bill the next day.

🔒 **What can go wrong:**
- OIDC trust with `repo:Aarushi14622/*` or no `sub` condition means **any** branch, or worse, any repo, can get credentials. This is the most common OIDC mistake.
- CloudTrail logs in the same account can be deleted by an attacker who gets admin. Real organisations send them to a separate log-archive account.
- A budget alert only *tells* you about cost. It doesn't stop spending.
