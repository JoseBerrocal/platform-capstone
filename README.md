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
│
├── apps/
│   ├── ingress-nginx.yaml
│   ├── metrics-server.yaml
│   ├── observability.yaml
│   └── poc09-app.yaml
│
├── bootstrap/
│   ├── argocd-values.yaml
│   └── install-argocd.sh
│
├── workloads/
│   └── poc09/
│       ├── client-cluster-ip-service.yml
│       ├── client-deployment.yml
│       ├── database-persistent-volume-claim.yml
│       ├── ingress-service.yml
│       ├── postgres-cluster-ip-service.yml
│       ├── postgres-deployment.yml
│       ├── postgres-secret.yaml
│       ├── server-cluster-ip-service.yml
│       └── server-deployment.yml
│
├── values/
│   ├── ingress-nginx-values.yaml
│   ├── metrics-server-values.yaml
│   └── kube-prometheus-stack-values.yaml
│
├── observability/
│   └── monitoring-ingress.yaml
│
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

Since ingress-nginx is not yet deployed, access ArgoCD using port-forward:

```bash
kubectl port-forward svc/argocd-server \
  -n argocd \
  8080:80
```

Login:

```bash
argocd login localhost:8080 --insecure
```

Deploy the platform:

```bash
kubectl apply -f root-app.yaml
```

Verify applications:

```bash
argocd app list
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

This ensures that platform services are deployed before application workloads.

---

## Verify Deployment

Check ArgoCD applications:

```bash
argocd app list
```

Check synchronization status:

```bash
argocd app get ingress-nginx

argocd app get metrics-server

argocd app get observability

argocd app get poc09-app
```

Verify namespaces:

```bash
kubectl get ns
```

Verify workloads:

```bash
kubectl get pods -A
```

---

## Application Access

Add the following entries to `/etc/hosts`:

```text
127.0.0.1 platform-demo.local
127.0.0.1 grafana.local
127.0.0.1 prometheus.local
127.0.0.1 argocd.local
```

Open the application:

```text
http://platform-demo.local
```

Test backend connectivity:

```bash
curl http://platform-demo.local/api/values/all
```

Expected response:

```json
{
  "rows": []
}
```

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

# Observability

## Components

The observability stack includes:

* Prometheus
* Grafana
* Alertmanager
* Node Exporter
* Kube State Metrics
* Metrics Server

---

## Verify Observability

Check pods:

```bash
kubectl get pods -n observability
```

Verify Prometheus:

```bash
kubectl get svc -n observability
```

Verify metrics collection:

```bash
kubectl top nodes

kubectl top pods -A
```

---

## Grafana Access

Open:

```text
http://grafana.local
```

Default credentials:

```text
admin
admin123
```

Verify dashboards:

* Kubernetes Cluster Overview
* Node Metrics
* Pod Metrics
* Container Metrics

---

## Prometheus Access

Open:

```text
http://prometheus.local
```

Verify targets:

```text
Status → Targets
```

Expected targets:

* Prometheus
* Node Exporter
* Kube State Metrics
* Metrics Server

---

## ArgoCD Access

After ingress-nginx is deployed and ArgoCD ingress is configured:

```text
http://argocd.local
```

Login:

```bash
argocd login argocd.local --insecure
```

---

## Validation Checklist

### GitOps

* [ ] ArgoCD healthy
* [ ] Root application synced
* [ ] ingress-nginx healthy
* [ ] metrics-server healthy
* [ ] observability healthy
* [ ] poc09-app healthy

### Application

* [ ] Frontend reachable through Ingress
* [ ] Backend reachable through Ingress
* [ ] PostgreSQL running
* [ ] PVC bound
* [ ] Secret configured

### Observability

* [ ] Prometheus running
* [ ] Grafana running
* [ ] Alertmanager running
* [ ] Node Exporter running
* [ ] Kube State Metrics running
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

Remove all platform namespaces:

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

```
```
