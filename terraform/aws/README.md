# Platform Capstone

Multi-cloud Platform Engineering project demonstrating Kubernetes platform deployment on AWS EKS and Azure AKS using Terraform, GitOps, and Observability.

## Technologies

* Terraform
* Kubernetes
* AWS EKS
* Azure AKS
* ArgoCD
* NGINX Ingress
* Prometheus
* Grafana
* Docker

## Features

* Infrastructure as Code with Terraform
* GitOps deployments with ArgoCD
* Multi-tenant application deployment
* Ingress-based traffic routing
* Cluster observability with Prometheus and Grafana
* AKS Cluster Autoscaling
* Persistent storage configuration
* AWS and Azure implementations

## Cloud Implementations

### AWS EKS

Resources:

* VPC
* Public Subnets
* Private Subnets
* NAT Gateway
* EKS Cluster
* Managed Node Group
* EKS Pod Identity Agent
* VPC CNI
* CoreDNS
* kube-proxy
* AWS EBS CSI Driver
* gp3 StorageClass

### Azure AKS

Resources:

* Resource Group
* Virtual Network
* AKS Cluster
* System Node Pool
* Cluster Autoscaler
* Azure Disk CSI Driver
* NGINX Ingress Controller
* ArgoCD
* Prometheus
* Grafana

## Verification

```bash
kubectl get nodes
kubectl get pods -A
kubectl get ingress -A
```

## Evidence

Deployment evidence is available under:

```text
evidence/aws
evidence/azure
```
