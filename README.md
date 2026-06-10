# Platform Capstone

## Introduction

This project demonstrates the deployment of a three-tier application on Kubernetes using GitOps principles and ArgoCD across local and cloud environments.

The application consists of:

* React frontend
* Node.js backend
* PostgreSQL database

The platform includes:

* ArgoCD App-of-Apps
* Kubernetes Deployments
* Kubernetes Services
* Persistent Storage (PVC)
* Kubernetes Secrets
* NGINX Ingress Controller
* Prometheus Monitoring
* Grafana Dashboards
* Metrics Server
* Terraform Infrastructure as Code
* AWS EKS Platform
* AWS EBS CSI Driver
* gp3 StorageClass

The goal of this project is to demonstrate practical Platform Engineering skills including Infrastructure as Code, GitOps, application deployment, networking, storage, observability, security, and troubleshooting.

---

## Architecture

```text
Git Repository
      |
      v
    ArgoCD
      |
      v
  Root Application
      |
      +----------------------------+
      |            |               |
      v            v               v
Ingress NGINX  Observability   Application
                                   |
                                   v
                          React + Node.js
                                   |
                                   v
                              PostgreSQL
                                   |
                                   v
                                 PVC
```

Observability Stack:

```text
Prometheus
Grafana
Alertmanager
Node Exporter
Kube State Metrics
Metrics Server
```

---

## Supported Platforms

### Local

* Docker Desktop Kubernetes

### AWS

* Amazon EKS
* Managed Node Groups
* AWS EBS CSI Driver
* gp3 StorageClass
* Terraform Infrastructure

Infrastructure code is located under:

```text
terraform/aws
```

---

## Repository Structure

```text
platform-capstone
├── README.md
├── root-app.yaml
├── apps/
│   ├── argocd-ingress.yaml
│   ├── ingress-nginx.yaml
│   ├── metrics-server.yaml
│   ├── observability.yaml
│   ├── observability-ingress.yaml
│   └── poc09-app.yaml
├── bootstrap/
│   ├── argocd-values.yaml
│   └── install-argocd.sh
├── terraform/
│   ├── README.md
│   └── aws/
│       ├── README.md
│       ├── eks.tf
│       ├── vpc.tf
│       ├── ebs-csi-irsa.tf
│       ├── storageclass.tf
│       ├── providers.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
├── workloads/
│   └── poc09/
├── values/
│   ├── ingress-nginx-values.yaml
│   ├── metrics-server-values.yaml
│   └── kube-prometheus-stack-values.yaml
└── .github/
```

---

## Prerequisites

### Local Kubernetes

Required tools:

* Docker Desktop
* Kubernetes enabled in Docker Desktop
* kubectl
* Helm
* ArgoCD CLI

Verify installation:

```bash
kubectl get nodes
helm version
argocd version --client
```

### AWS

Required tools:

* AWS CLI
* Terraform
* kubectl
* Helm

Verify AWS access:

```bash
aws sts get-caller-identity
```

---

## AWS Infrastructure Deployment

Navigate to:

```bash
cd terraform/aws
```

Initialize:

```bash
terraform init
```

Validate:

```bash
terraform fmt -recursive
terraform validate
```

Plan:

```bash
terraform plan
```

Deploy:

```bash
terraform apply
```

Configure kubectl:

```bash
aws eks update-kubeconfig \
  --region eu-west-1 \
  --name platform-capstone
```

Verify:

```bash
kubectl get nodes
kubectl get pods -A
kubectl get storageclass
```

Expected:

```text
Node Ready
EBS CSI ACTIVE
gp3 (default)
```

---

## Bootstrap ArgoCD

Install ArgoCD:

```bash
./bootstrap/install-argocd.sh
```

Verify:

```bash
kubectl get pods -n argocd
```

Get the initial admin password:

```bash
kubectl get secret argocd-initial-admin-secret \
  -n argocd \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

Deploy the platform:

```bash
kubectl apply -f root-app.yaml
```

Verify applications:

```bash
kubectl get applications -n argocd
```

---

## GitOps Deployment Order

The platform uses ArgoCD Sync Waves.

```text
Wave 0 → ingress-nginx
Wave 1 → metrics-server
Wave 2 → observability
Wave 3 → poc09-app
```

This guarantees that platform services are available before application deployment.

---

## Verify Deployment

Applications:

```bash
kubectl get applications -n argocd
```

Workloads:

```bash
kubectl get pods -A
```

Ingress:

```bash
kubectl get ingress -A
```

Expected:

```text
argocd-ingress
monitoring-ingress
platform-demo
```

---

## Local DNS Configuration

For local environments add:

```text
127.0.0.1 argocd.local
127.0.0.1 grafana.local
127.0.0.1 prometheus.local
127.0.0.1 platform-demo.local
```

---

## Application Access

Frontend:

```text
http://platform-demo.local
```

Backend:

```bash
curl http://platform-demo.local/api/values/all
```

---

## ArgoCD Access

```text
http://argocd.local
```

---

## Grafana Access

```text
http://grafana.local
```

Default credentials:

```text
admin
admin123
```

---

## Prometheus Access

```text
http://prometheus.local
```

---

## Metrics Validation

Verify cluster metrics:

```bash
kubectl top nodes
kubectl top pods -A
```

Verify Grafana dashboards display:

* Pod CPU
* Pod Memory
* Container CPU
* Container Memory

---

## Kubernetes Resources

### Deployments

* Frontend Deployment
* Backend Deployment
* PostgreSQL Deployment

### Services

* Frontend ClusterIP Service
* Backend ClusterIP Service
* PostgreSQL ClusterIP Service

### Storage

* Persistent Volume Claim
* AWS EBS CSI Driver
* gp3 StorageClass

### Secrets

* PostgreSQL Password Secret

### Networking

* NGINX Ingress

---

## Validation Checklist

### Infrastructure

* [ ] Terraform applied successfully
* [ ] EKS cluster active
* [ ] Node group healthy
* [ ] EBS CSI active
* [ ] gp3 default StorageClass

### GitOps

* [ ] ArgoCD healthy
* [ ] Root application synced
* [ ] ingress-nginx healthy
* [ ] metrics-server healthy
* [ ] observability healthy
* [ ] poc09-app healthy

### Access

* [ ] argocd.local reachable
* [ ] grafana.local reachable
* [ ] prometheus.local reachable
* [ ] platform-demo.local reachable

### Application

* [ ] Frontend reachable
* [ ] Backend reachable
* [ ] PostgreSQL running
* [ ] PVC bound
* [ ] Secret configured

### Observability

* [ ] Prometheus running
* [ ] Grafana running
* [ ] Metrics Server running
* [ ] kubectl top working
* [ ] Dashboards displaying metrics

---

## Cleanup

Delete ArgoCD application:

```bash
kubectl delete -f root-app.yaml
```

Delete ArgoCD:

```bash
kubectl delete namespace argocd
```

Delete platform namespaces:

```bash
kubectl delete namespace ingress-nginx
kubectl delete namespace observability
kubectl delete namespace poc09
```

Delete AWS infrastructure:

```bash
cd terraform/aws
terraform destroy
```

---

## Learning Objectives

This project demonstrates:

* Terraform
* Infrastructure as Code
* Amazon EKS
* Kubernetes Workloads
* Kubernetes Networking
* Kubernetes Storage
* Kubernetes Secrets
* AWS EBS CSI Driver
* gp3 StorageClass
* NGINX Ingress
* Metrics Server
* Prometheus Monitoring
* Grafana Dashboards
* ArgoCD GitOps
* App-of-Apps Pattern
* Sync Waves
* Platform Engineering Fundamentals
* Kubernetes Troubleshooting
* Cloud-Native Operations
