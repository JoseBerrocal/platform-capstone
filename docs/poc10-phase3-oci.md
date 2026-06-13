# POC10 Phase 3 - OCI Helm Distribution

## Objective

Distribute the tenant platform as a reusable OCI Helm chart and deploy tenants through ArgoCD using GitHub Container Registry (GHCR).

This phase demonstrates platform standardization and tenant onboarding through a centralized chart repository.

---

## Components

### OCI Registry

GitHub Container Registry (GHCR)

### Helm Chart

```text
charts/tenant-platform
```

### OCI Artifact

```text
artifacts/helm/tenant-platform-0.1.0.tgz
```

### OCI Registry Path

```text
ghcr.io/joseberrocal/platform-capstone/tenant-platform
```

### ArgoCD Applications

```text
apps/poc10-aks-tenant-a-oci.yaml
apps/poc10-aks-tenant-b-oci.yaml
```

---

## Workflow

```text
Helm Chart
     |
     v
helm package
     |
     v
GHCR OCI Registry
     |
     v
ArgoCD
     |
     v
Tenant A
Tenant B
```

---

## Package Chart

```bash
helm package charts/tenant-platform \
  --destination artifacts/helm
```

Expected:

```text
artifacts/helm/tenant-platform-0.1.0.tgz
```

---

## Publish Chart

Login:

```bash
echo $GITHUB_TOKEN | helm registry login ghcr.io \
  -u joseberrocal \
  --password-stdin
```

Push:

```bash
helm push artifacts/helm/tenant-platform-0.1.0.tgz \
  oci://ghcr.io/joseberrocal/platform-capstone
```

---

## Validate Registry

Pull:

```bash
helm pull \
  oci://ghcr.io/joseberrocal/platform-capstone/tenant-platform \
  --version 0.1.0
```

Inspect:

```bash
helm show chart \
  oci://ghcr.io/joseberrocal/platform-capstone/tenant-platform \
  --version 0.1.0
```

---

## ArgoCD Deployment

Deploy OCI applications:

```bash
kubectl apply -f apps/poc10-aks-tenant-a-oci.yaml

kubectl apply -f apps/poc10-aks-tenant-b-oci.yaml
```

Verify:

```bash
kubectl get applications -n argocd
```

Expected:

```text
poc10-aks-tenant-a
poc10-aks-tenant-b
```

---

## Validation

Verify tenants:

```bash
kubectl get pods -n poc10-aks-tenant-a

kubectl get pods -n poc10-aks-tenant-b
```

Verify platform controls:

```bash
kubectl get quota -A

kubectl get limitrange -A

kubectl get networkpolicy -A
```

Verify ArgoCD:

```bash
kubectl get applications -n argocd
```

---

## Evidence

Evidence collected under:

```text
evidence/azure
```

Examples:

```text
argocd-applications.txt
pods.txt
nodes.txt
resourcequotas.txt
limitranges.txt
networkpolicies.txt
screenshots/
```

---

## Key Concepts

* OCI Helm Charts
* GitHub Container Registry (GHCR)
* ArgoCD OCI Applications
* Platform Reusability
* Tenant Standardization
* GitOps Delivery
* Multi-Tenant Kubernetes Platforms

---

## Outcome

The tenant platform is now:

* Reusable
* Versioned
* Registry-based
* GitOps managed
* Deployable across multiple Kubernetes clusters

New tenants can be onboarded by creating a values file and an ArgoCD Application without duplicating Kubernetes manifests.
