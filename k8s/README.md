# Kubernetes (Day 3)

Plain-word version: Kubernetes runs containers for you. Kyverno is a gatekeeper inside the cluster. It checks every pod against our rules (policies) before letting it start. Writing those rules as files in git is **Policy as Code**.

| File | What it does |
|---|---|
| `namespace.yaml` | Own space for MediPay; Kubernetes' built-in `restricted` Pod Security profile is enforced |
| `serviceaccount.yaml` | App identity with **no** permissions and no API token (least privilege; RBAC by omission) |
| `deployment.yaml` | Runs the app as UID 10001, read-only filesystem, all Linux capabilities dropped, image by digest |
| `service.yaml` | Stable address for the app inside the cluster |
| `networkpolicy.yaml` | Default deny all traffic, then allow only port 8000 in. No outbound access at all |

Policies are in `../policies/kyverno/`:

| Policy | Blocks | Tested in CI? |
|---|---|---|
| `disallow-root` | Pods that may run as root or escalate privileges | Yes (`k8s-policy` job) |
| `require-pinned-trusted-images` | Images from other registries, or pinned by tag | Yes |
| `verify-image-signature` | Images not signed by this repo's CI on `main` (Day 2 Cosign) | No: needs a live registry. Try it in kind (below) |

## Try it in a local cluster (optional, on the VM)

```bash
kind create cluster --name medipay            # a throwaway cluster in Docker
kubectl create -f https://github.com/kyverno/kyverno/releases/download/v1.19.2/install.yaml
kubectl apply -f policies/kyverno/
kubectl apply -f k8s/
kubectl run root-test --image=python:3.12-slim -n medipay   # should be REFUSED
kind delete cluster --name medipay            # clean up
```

**What you should see:** the `root-test` pod is refused, with Kyverno's message ("Images must come from ghcr.io/aarushi14622/").

🔒 **What can go wrong:**
- Policies in `Audit` mode only log. Ours are `Enforce`.
- Kyverno's webhook can be set to fail open (`failurePolicy: Ignore`). Then if Kyverno is down, everything gets in.
- NetworkPolicies do nothing unless the cluster's network plugin supports them. kind's default plugin (kindnet) supports them in recent versions. Check yours before relying on it.
