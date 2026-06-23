# Platform Capstone

## Overview

Platform Engineering project demonstrating:

* AWS EKS
* Azure AKS
* Terraform
* ArgoCD GitOps
* Helm
* Multi-tenant Kubernetes workloads
* Prometheus & Grafana
* NGINX Ingress
* Kubernetes Networking
* Stateful Workload Recovery
* GitOps Drift Recovery
* Production Incident Troubleshooting

Application stack:

* React
* Node.js
* PostgreSQL

---

## Architecture

```text
Git Repository
      |
      v
    ArgoCD
      |
      v
Platform Services
      |
      v
Tenant Workloads
      |
      v
React + Node.js + PostgreSQL
```

---

## Supported Platforms

### AWS

Features:

* EKS
* Managed Node Groups
* EBS CSI Driver
* gp3 StorageClass

Infrastructure code:

```text
terraform/aws
```

### Azure

Features:

* AKS
* Azure Managed Disks
* Azure Network Policies

Infrastructure code:

```text
terraform/azure
```

---

## GitOps Platform

Platform services managed through ArgoCD:

* Ingress NGINX
* Metrics Server
* Prometheus
* Grafana
* Tenant Applications

Applications:

```text
apps/
```

Bootstrap:

```text
bootstrap/
```

---

## Multi-Tenant Platform (POC10)

Features:

* Namespace isolation
* ResourceQuota
* LimitRange
* NetworkPolicy
* Shared Ingress
* Helm tenant onboarding
* ArgoCD GitOps

Reusable Helm chart:

```text
charts/tenant-platform
```

Tenant configuration:

```text
workloads/poc10-aks/
├── tenant-a-values.yaml
└── tenant-b-values.yaml
```

Deployment options:

* Raw Kubernetes manifests
* Helm chart
* OCI Helm chart via GitHub Container Registry (GHCR)
* ArgoCD OCI deployment

---

## Operational Recovery Scenarios

The repository includes operational Kubernetes recovery exercises focused on real-world production incidents.

### POC11 — Stateful Storage Recovery

Focus:

- Persistent Volumes
- Persistent Volume Claims
- StorageClass
- PostgreSQL recovery
- Stateful workload troubleshooting

### POC12 — GitOps Drift Recovery

Focus:

- ArgoCD reconciliation
- Drift detection
- Git as source of truth
- Automated recovery

### POC13 — Kubernetes Networking Incident

Focus:

- Services
- Endpoints
- Ingress
- NetworkPolicy
- Production networking troubleshooting

Typical troubleshooting workflow:

```text
Ingress
   ↓
Service
   ↓
Endpoints
   ↓
Pod
```

### POC18 — Platform Security & Developer Guardrails

Focus:

* RBAC
* Service Accounts
* Workload Identity
* Least Privilege
* Network Policies
* Secrets Management
* Pod Security
* GitOps Security Controls
* Security Incident Response

Completed stages:

* Stage 1 — RBAC & Multi-Tenant Access Control
* Stage 2 — Service Accounts & Workload Identity
* Stage 3 — Network Segmentation
* Stage 4 — Secrets Management
* Stage 5 — Secure Helm Platform Defaults
* Stage 6 — GitOps Security Controls
* Stage 7 — Security Incident Response & RCA

Security controls implemented:

* Namespace isolation
* Multi-tenant RBAC
* Dedicated workload identities
* Workload-level RBAC
* Network segmentation
* Secret-based credential management
* Secure container defaults
* Non-root execution
* Read-only root filesystems
* RuntimeDefault seccomp profiles
* Pod Security Admission enforcement
* GitOps-managed security configuration

Operational validation:

* Secret failure recovery
* Network security validation
* Pod Security Admission enforcement testing
* Security incident troubleshooting
* Root cause analysis documentation

Documentation:

```text
docs/poc18-platform-security.md
docs/poc18-phase7-security-incident-rca.md
```

---

## Repository Structure

```text
platform-capstone
├── apps/
├── artifacts/
├── bootstrap/
├── charts/
├── client/
├── docs/
├── evidence/
├── observability/
├── server/
├── terraform/
│   ├── aws/
│   └── azure/
├── values/
├── workloads/
└── README.md
```

---

## Validation

Verify ArgoCD:

```bash
kubectl get applications -n argocd
```

Verify workloads:

```bash
kubectl get pods -A
```

Validate Helm chart:

```bash
helm template tenant-a charts/tenant-platform \
  -f workloads/poc10-aks/tenant-a-values.yaml

helm template tenant-b charts/tenant-platform \
  -f workloads/poc10-aks/tenant-b-values.yaml
```

---

## Evidence

Deployment evidence and screenshots:

```text
evidence/aws
evidence/azure
```

---

## Documentation

```text
docs/
├── poc09.md
├── poc10-phase1-aks.md
├── poc10-phase2-helm.md
├── poc10-phase3-oci.md
├── poc11-stateful-storage-recovery.md
├── poc12-gitops-drift-recovery.md
├── poc13-kubernetes-networking-incident.md
├── poc14-reliability-observability.md
├── poc18-phase7-security-incident-rca.md
├── poc18-platform-security.md
├── platform-operations.md
└── README.md
```

---

## Learning Objectives

* Terraform
* AWS EKS
* Azure AKS
* ArgoCD GitOps
* Helm
* OCI Registries
* GitHub Container Registry (GHCR)
* Kubernetes Networking
* Kubernetes Storage
* Multi-Tenant Platforms
* Observability
* Platform Engineering
* Kubernetes Security
* RBAC
* Service Accounts
* Workload Identity
* Least Privilege
* Kubernetes Security
* Network Policies
* Pod Security Admission
* Secrets Management
* Security Incident Response
* Root Cause Analysis
* GitOps Security Controls
* Multi-Tenant Platform Security