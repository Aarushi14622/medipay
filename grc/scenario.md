# Phase 2: The scenario (fictional)

> **MediPay is a fictional organisation.** Every name, number and supplier relationship below is invented for this portfolio. Real supplier *products* are named only as typical categories, with no claims about any real company's security.

## Who MediPay is

| | |
|---|---|
| **What it does** | Processes patient billing and insurance claims for **NHS trusts** (private patient units, overseas visitor charging) and **private clinics** in England |
| **Size** | About 250 staff, one office in London, hybrid working |
| **Customers** | 12 NHS trusts and about 40 private clinics |
| **Data** | Patient names, dates of birth, NHS numbers, treatment codes, insurer details: **special category health data** under UK GDPR |
| **Tech** | The Patients API (this repo), containers, GitHub, AWS in London (`eu-west-2`), Microsoft 365 |
| **CISO** | Reports to the COO. A security team of 3 |

## Why supply chain risk matters to MediPay

MediPay is in the middle of a chain:
- **Upstream:** MediPay depends on suppliers (cloud, code platform, payment processor, a claims-coding vendor and so on).
- **Downstream:** NHS trusts depend on MediPay. If MediPay goes down, trusts can't bill. If MediPay is breached, trusts' patient data leaks.

**Could MediPay itself be designated a critical supplier under the Bill?** It depends on the scenario details: whether it supplies an operator of essential services directly, the impact of its failure on care, its integration with trust systems, and its scale. For this portfolio, **MediPay is not designated**. Billing disruption delays revenue, not clinical care, and the regulator would consider substitutes. **But it treats its NHS contracts as if it could be** (decision D11), because trusts will ask the same questions anyway.

## Supplier landscape (summary)

The full inventory and tiering is in [`tprm/a-supplier-inventory.md`](tprm/a-supplier-inventory.md).

| Category | Example (fictional or generic) |
|---|---|
| Cloud hosting | AWS (London region) |
| Code and CI | GitHub, including Actions and Dependabot |
| Container and software supply chain | Docker Hub (base images), PyPI (Python packages), security tool vendors |
| Payments | "PayBridge Ltd", a card payment processor |
| Claims coding | "CodeRight Health", a SaaS vendor for clinical coding |
| Office and identity | Microsoft 365 |
| Support | "HelpDesk Partners", outsourced IT support with admin access |
| Print and post | "MailHouse UK", which prints and posts patient invoices |

## Risk appetite (Board-approved, fictional)

| Area | Appetite | In practice |
|---|---|---|
| Patient data confidentiality | **Very low** | No supplier handles patient data without a contract, due diligence and UK or adequate-country hosting |
| Availability of billing | **Low to moderate** | A day's outage is survivable. A week isn't. Critical suppliers need an exit or fallback plan |
| Software supply chain | **Low** | All code dependencies pinned, scanned and reviewed (the technical labs show this in practice) |
| New suppliers | **Moderate** | Speed matters, but tier 1 suppliers need security review before signing |
| Regulatory | **Very low** | Meet the Pledge actions and prepare for the Bill as if designated |
