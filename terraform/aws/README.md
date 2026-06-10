# AWS EKS Platform

Terraform configuration for the AWS implementation of the Platform Capstone project.

## Resources

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

## Prerequisites

* AWS CLI
* Terraform
* kubectl
* AWS Credentials

## Initialize

```bash
terraform init
```

## Validate

```bash
terraform fmt -recursive
terraform validate
```

## Plan

```bash
terraform plan
```

## Deploy

```bash
terraform apply
```

## Configure kubectl

```bash
aws eks update-kubeconfig \
  --region eu-west-1 \
  --name platform-capstone
```

## Verify

```bash
kubectl get nodes
kubectl get pods -A
kubectl get storageclass
```

## Destroy

```bash
terraform destroy
```
