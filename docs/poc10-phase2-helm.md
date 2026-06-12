# POC10 Phase 2 - Helm Standardization

## Objective

Standardize tenant onboarding by replacing duplicated Kubernetes manifests with a reusable Helm chart.

## Initial State

Each tenant maintained its own set of Kubernetes manifests:

```text
workloads/poc10-aks/poc10-aks-tenant-a/
workloads/poc10-aks/poc10-aks-tenant-b/
```

This approach introduced duplication and increased maintenance effort.

## Solution

Created a reusable Helm chart:

```text
charts/tenant-platform
```

The chart templates:

* ResourceQuota
* LimitRange
* NetworkPolicy
* Client Deployment
* Server Deployment
* PostgreSQL Deployment
* Services
* PVC
* Secret
* Ingress

Tenant-specific configuration is provided through values files:

```text
workloads/poc10-aks/tenant-a-values.yaml
workloads/poc10-aks/tenant-b-values.yaml
```

## ArgoCD Migration

Updated ArgoCD Applications to deploy:

```text
charts/tenant-platform
```

instead of:

```text
workloads/poc10-aks/poc10-aks-tenant-a
workloads/poc10-aks/poc10-aks-tenant-b
```

Validation confirmed:

```text
sourceType: Helm
```

for both tenants.

## Validation

Rendered manifests:

```bash
helm template tenant-a charts/tenant-platform \
  -f workloads/poc10-aks/tenant-a-values.yaml

helm template tenant-b charts/tenant-platform \
  -f workloads/poc10-aks/tenant-b-values.yaml
```

Validated Kubernetes resources:

```bash
kubectl apply --dry-run=client -f rendered.yaml
```

Verified ArgoCD synchronization:

```bash
kubectl get applications -n argocd
```

## Benefits

* Reduced manifest duplication
* Reusable tenant onboarding process
* Consistent platform configuration
* Easier tenant provisioning
* GitOps-driven Helm deployments

## Result

Successfully migrated tenant deployments from raw manifests to a reusable Helm chart managed by ArgoCD.
