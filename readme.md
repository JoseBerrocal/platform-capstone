Your README should reflect **your implementation**, not the original fork.

# Platform Demo Kubernetes

## Introduction

This project demonstrates the deployment of a three-tier application on Kubernetes using Docker Desktop Kubernetes.

The application consists of:

* React frontend
* Node.js backend
* PostgreSQL database

The platform includes:

* Kubernetes Deployments
* Kubernetes Services
* Persistent Storage (PVC)
* Kubernetes Secrets
* NGINX Ingress
* Prometheus Monitoring
* Grafana Dashboards
* Metrics Server

The goal of this project is to demonstrate practical Platform Engineering and Kubernetes operational skills including application deployment, networking, storage, observability, and troubleshooting.

---

## Architecture

```text
Browser
   |
   v
NGINX Ingress
   |
   +--------------------+
   |                    |
   v                    v
React Frontend      Node.js Backend
                          |
                          v
                     PostgreSQL
                          |
                          v
                 Persistent Volume Claim
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

## Technologies Used

### Application

* React
* Node.js
* PostgreSQL

### Platform

* Docker
* Kubernetes
* NGINX Ingress Controller

### Observability

* Prometheus
* Grafana
* Alertmanager
* Node Exporter
* Kube State Metrics
* Metrics Server

---

## Repository Structure

```text
platform-demo-k8s
├── client/
├── server/
├── k8s/
│   ├── client-deployment.yml
│   ├── server-deployment.yml
│   ├── postgres-deployment.yml
│   ├── client-cluster-ip-service.yml
│   ├── server-cluster-ip-service.yml
│   ├── postgres-cluster-ip-service.yml
│   ├── database-persistent-volume-claim.yml
│   ├── postgres-secret.yaml
│   └── ingress-service.yml
├── observability/
│   ├── install.sh
│   ├── grafana-ingress.yaml
│   ├── prometheus-ingress.yaml
│   └── values/
│       └── kube-prometheus-stack-values.yaml
└── README.md
```

---

## Prerequisites

* Docker Desktop
* Kubernetes enabled in Docker Desktop
* kubectl
* Helm
* NGINX Ingress Controller

Verify:

```bash
kubectl get nodes
helm version
```

---

## Application Deployment

Deploy the application:

```bash
kubectl apply -f k8s/
```

Verify:

```bash
kubectl get all -n poc09
```

---

## Application Access

Add the following entry to `/etc/hosts`:

```text
127.0.0.1 platform-demo.local
```

Open:

```text
http://platform-demo.local
```

Test backend connectivity:

```bash
curl http://platform-demo.local/api/values/all
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

## Installation

Deploy the complete observability stack:

```bash
./observability/install.sh
```

The script installs:

* Prometheus
* Grafana
* Alertmanager
* Node Exporter
* Kube State Metrics
* Metrics Server

---

## Verification

Verify observability components:

```bash
kubectl get pods -n observability
```

Verify Kubernetes metrics:

```bash
kubectl top nodes

kubectl top pods -A
```

---

## Grafana Access

Add:

```text
127.0.0.1 grafana.local
127.0.0.1 prometheus.local
```

Verify ingress:

```bash
kubectl get ingress -n observability
```

Open Grafana:

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

Open:

```text
http://prometheus.local
```

---

## Validation Checklist

* [ ] Frontend reachable through Ingress
* [ ] Backend reachable through Ingress
* [ ] PostgreSQL running
* [ ] Persistent Volume Claim bound
* [ ] Secret configured
* [ ] Prometheus running
* [ ] Grafana running
* [ ] Metrics Server running
* [ ] kubectl top working
* [ ] Grafana dashboards displaying metrics

---

## Cleanup

Remove the application:

```bash
kubectl delete -f k8s/
```

Remove observability:

```bash
helm uninstall monitoring -n observability

kubectl delete namespace observability
```

This version looks much closer to a Platform Engineer portfolio project and aligns with the type of Kubernetes, networking, storage, and observability topics HostPapa is likely to ask about.
