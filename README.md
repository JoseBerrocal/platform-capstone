# Platform Capstone

## Introduction

This project demonstrates the deployment of a three-tier application on Kubernetes using GitOps principles and ArgoCD.

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

The goal of this project is to demonstrate practical Platform Engineering skills including GitOps, application deployment, networking, storage, observability, and troubleshooting.

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

## Repository Structure

```text
platform-capstone
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
├── workloads/
│   └── poc09/
├── values/
│   ├── ingress-nginx-values.yaml
│   ├── metrics-server-values.yaml
│   └── kube-prometheus-stack-values.yaml
└── README.md
```

---

## Prerequisites

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

---

# Bootstrap ArgoCD

Install ArgoCD:

```bash
./bootstrap/install-argocd.sh
```

Verify ArgoCD:

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

Deployment order:

```text
Wave 0 → ingress-nginx
Wave 1 → metrics-server
Wave 2 → observability
Wave 3 → poc09-app
```

This guarantees that platform services are available before application deployment.

---

## Verify Deployment

Check applications:

```bash
kubectl get applications -n argocd
```

Verify workloads:

```bash
kubectl get pods -A
```

Verify ingress resources:

```bash
kubectl get ingress -A
```

Expected:

```text
argocd-ingress
monitoring-ingress
ingress-service
```

---

## Local DNS Configuration

Add the following entries to `/etc/hosts`:

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

Backend test:

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

Verify Grafana displays:

* Pod CPU
* Pod Memory
* Container CPU
* Container Memory

---

## Kubernetes Resources

The application uses:

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

### Secrets

* PostgreSQL Password Secret

### Networking

* NGINX Ingress

---

## Validation Checklist

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

* [ ] Frontend reachable through Ingress
* [ ] Backend reachable through Ingress
* [ ] PostgreSQL running
* [ ] PVC bound
* [ ] Secret configured

### Observability

* [ ] Prometheus running
* [ ] Grafana running
* [ ] Metrics Server running
* [ ] kubectl top working
* [ ] Grafana dashboards displaying metrics

---

## Cleanup

Remove the root application:

```bash
kubectl delete -f root-app.yaml
```

Remove ArgoCD:

```bash
kubectl delete namespace argocd
```

Remove platform namespaces:

```bash
kubectl delete namespace ingress-nginx
kubectl delete namespace observability
kubectl delete namespace poc09
```

---

## Learning Objectives

This project demonstrates:

* Kubernetes Workloads
* Kubernetes Networking
* Kubernetes Storage
* Kubernetes Secrets
* NGINX Ingress
* Metrics Server
* Prometheus Monitoring
* Grafana Dashboards
* ArgoCD GitOps
* App-of-Apps Pattern
* Sync Waves
* Platform Engineering Fundamentals
* Kubernetes Troubleshooting
