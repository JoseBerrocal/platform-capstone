# Terraform Infrastructure

Infrastructure as Code for the Platform Capstone project.

## Providers

* AWS (EKS)
* Azure (AKS)

## Structure

```text
terraform/
├── README.md
├── aws/
└── azure/
```

## Features

* Terraform Infrastructure as Code
* AWS EKS deployment
* Azure AKS deployment
* Managed Kubernetes clusters
* Autoscaling node pools
* Cloud-native storage integration
* Reusable variables and environment configuration

## Deploy

Navigate to the desired provider directory and execute:

```bash
terraform init
terraform plan
terraform apply
```

## Validate

```bash
terraform fmt -recursive
terraform validate
```

## Destroy

```bash
terraform destroy
```
