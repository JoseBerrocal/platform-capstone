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
└── platform-operations.md
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
