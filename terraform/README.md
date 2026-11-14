# Terraform (Days 4 to 6)

Plain-word version: Terraform describes cloud resources in text files. Then it creates them for you. Because the files are code, we can **scan them before anything exists**. Finding a public bucket in a PR is much cheaper than finding it in AWS.

| Folder | What it is | Deployed? |
|---|---|---|
| `evidence-bucket/` | Day 4: S3 bucket for audit evidence (SBOMs, scan reports): private, encrypted with KMS, versioned, access-logged, HTTPS only, London only | Optional, on LocalStack (free, local) |
| `aws-baseline/` | Days 5 and 6: account baseline: GitHub OIDC role (no stored keys), CloudTrail, budget alert, password policy | **No.** Scanned only (decision: no AWS account in this project) |

## The two scanners

| Tool | Question it answers | Where the rules come from |
|---|---|---|
| **Checkov** | "Does this follow general cloud best practice?" | Hundreds of built-in checks (CIS-style) |
| **Conftest** (OPA/Rego) | "Does this follow **MediPay's** rules?" | `policies/conftest/terraform.rego`, written by us: UK region only, every bucket classified, no public access |

Skipped Checkov checks are written **next to the resource** with a reason (`#checkov:skip=ID:reason`), so every exception is visible in review. That's a risk acceptance, in code.

## Try it locally (optional, on the VM)

```bash
cd terraform/evidence-bucket
docker run -d --name localstack -p 4566:4566 localstack/localstack   # fake AWS
terraform init && terraform plan          # use_localstack defaults to true
checkov -d . --compact                    # should show 0 failed
```

🔒 **What can go wrong:**
- `#checkov:skip` without a reason turns the scanner into theatre. Reviewers must challenge each skip.
- Terraform state files contain secrets in plain text. Never commit `*.tfstate` (already in `.gitignore`).
- A scanner only sees what's in code. Changes made by hand in the AWS console ("drift") are invisible to it.
