# POC18 — Platform Security & Developer Guardrails

## Objective

Implement production-oriented Kubernetes security controls for a multi-tenant platform running on Amazon EKS.

The goal is to provide secure developer self-service while enforcing platform guardrails such as RBAC, workload identity, least privilege, and tenant isolation.

---

## Environment

Platform Components:

* Amazon EKS
* ArgoCD
* Helm
* Tenant Platform Chart
* Multi-Tenant Applications

Namespaces:

* poc18-security-tenant-a
* poc18-security-tenant-b

---

## Stage 1 — RBAC & Multi-Tenant Access Control

Implemented:

* Developer Role per tenant
* ReadOnly Role per tenant
* Developer RoleBinding per tenant
* ReadOnly RoleBinding per tenant

Validated:

* developer-user-a can manage resources only in tenant-a
* developer-user-a cannot manage tenant-b
* developer-user-b can manage resources only in tenant-b
* developer-user-b cannot manage tenant-a
* readonly users can inspect resources
* readonly users cannot modify workloads
* developer users cannot delete namespaces

Evidence:

```text
evidence/aws/poc18-platform-security/stage1-rbac/
```

---
## Stage 2 — Service Accounts & Workload Identity

Implemented:

### Tenant A

Workloads:

* client-deployment
* server-deployment

ServiceAccounts:

* client-sa
* server-sa

### Tenant B

Workloads:

* client-deployment
* server-deployment
* postgres-deployment

ServiceAccounts:

* client-sa
* server-sa
* postgres-sa

### Helm Integration

The tenant-platform Helm chart was extended to support workload-specific ServiceAccounts.

ServiceAccount assignment is managed through tenant values files and deployed through ArgoCD GitOps workflows.

Additional RBAC:

* server-configmap-reader Role in tenant-a
* server-configmap-reader RoleBinding in tenant-a
* server-configmap-reader Role in tenant-b
* server-configmap-reader RoleBinding in tenant-b

Validated:

* Tenant A client pods use client-sa
* Tenant A server pods use server-sa
* Tenant B client pods use client-sa
* Tenant B server pods use server-sa
* Tenant B postgres pod uses postgres-sa
* server-sa can read ConfigMaps in its own namespace
* server-sa cannot create Deployments
* client-sa cannot read ConfigMaps
* postgres-sa does not receive unnecessary permissions

Least Privilege Design:

* server-sa receives only the permissions required to read ConfigMaps
* client-sa does not receive Kubernetes API permissions
* postgres-sa does not receive Kubernetes API permissions

Evidence:

```text
evidence/aws/poc18-platform-security/stage2-service-accounts/
```
---

## Security Concepts Demonstrated

* Kubernetes RBAC
* Authorization
* Service Accounts
* Workload Identity
* Least Privilege
* Workload-Level RBAC
* Namespace Isolation
* Multi-Tenant Platform Security
* GitOps-Managed Security Configuration
* Platform Governance

---

## Outcome

POC18 establishes Kubernetes security guardrails for a multi-tenant platform.

The platform now supports:

* Namespace-level access control for users
* Dedicated workload identities for application components
* Least-privilege workload permissions
* GitOps-managed security configuration

These controls reduce unnecessary permissions and improve tenant isolation and platform security.
