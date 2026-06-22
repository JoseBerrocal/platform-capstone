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

## Stage 3 — Network Security & Tenant Isolation

Implemented:

* Default deny ingress and egress policies
* DNS egress policy
* Ingress Controller access policies
* Client-to-server communication policies
* Server-to-PostgreSQL communication policies
* Server-to-CloudNativePG communication policies

Validated:

* Client can reach application server
* Server can reach PostgreSQL
* Server can reach external CloudNativePG
* Default deny policies are deployed through the tenant platform chart
* NetworkPolicies are managed through GitOps

Additional Findings:

* CNPG ingress isolation was tested by applying a deny-all ingress NetworkPolicy in the postgres-ha namespace.
* Traffic to postgres-ha-rw remained reachable from tenant workloads.
* Additional investigation is required to determine why ingress restrictions were not enforced for this traffic path in the current environment.

Network Guardrails:

* Zero-trust networking model
* Least-privilege east-west traffic
* Database isolation
* Tenant network segmentation
* GitOps-managed NetworkPolicies

Evidence:

```text
evidence/aws/poc18-platform-security/stage3-network-security/
```

---

## Stage 4 — Secrets Management

Implemented:

* Database credentials stored as Kubernetes Secrets.
* Tenant A uses `postgres-ha-app-secret` for external CloudNativePG credentials.
* Tenant B uses `pgpassword` for internal PostgreSQL credentials.
* Secret configuration is managed through the tenant Helm values and deployed by ArgoCD.

Validated:

* Tenant A server consumes database credentials from Kubernetes Secrets.
* Tenant B server consumes database credentials from Kubernetes Secrets.
* Invalid Tenant A database credentials cause application/database connection failure.
* Restoring the correct secret value recovers the workload after restart.

Evidence:

```text
evidence/aws/poc18-platform-security/stage4-secrets-management/
```

---

## Stage 5 — Secure Helm Platform Defaults

Implemented:

* runAsNonRoot=true
* allowPrivilegeEscalation=false
* readOnlyRootFilesystem=true
* RuntimeDefault seccomp profile

Validation:

* Workloads run as non-root users.
* Secure defaults are inherited from the tenant-platform Helm chart.
* React client required a writable cache directory.
* An emptyDir volume was added for /app/node_modules/.cache.
* Applications remained functional after security hardening.

Evidence:

```text
evidence/aws/poc18-platform-security/stage5-secure-defaults/
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
* Network Policies
* Zero Trust Networking
* East-West Traffic Control
* Database Isolation
* Runtime Workload Segmentation
* Kubernetes Secrets
* Secret Consumption
* Credential Failure Recovery
* GitOps-Managed Secret Configuration
* Pod Security
* Secure Container Defaults
* Non-Root Containers
* Runtime Security Hardening
* Seccomp Profiles
* Read-Only Root Filesystems
* Platform Guardrails
* Secure-by-Default Platforms

---

## Outcome

POC18 establishes Kubernetes security guardrails for a multi-tenant platform.

The platform now supports:

* Namespace-level access control for users
* Dedicated workload identities for application components
* Least-privilege workload permissions
* Network-level workload isolation
* Database access controls
* GitOps-managed secret configuration
* Non-root workload execution
* Runtime security hardening through secure Helm defaults
* Secure-by-default onboarding for new platform tenants

All security controls are managed through GitOps workflows and inherited automatically by onboarded workloads through the tenant-platform Helm chart.

These controls reduce unnecessary permissions, improve tenant isolation, enforce security standards, and provide reusable platform guardrails for multi-tenant Kubernetes environments.
