# POC09 - Three-Tier Application

## Objective

Deploy a production-style three-tier application on Kubernetes using GitOps principles.

## Components

- React frontend
- Node.js backend
- PostgreSQL database
- Persistent Volume Claim
- Kubernetes Secret
- NGINX Ingress
- ArgoCD

## Architecture

Frontend → Backend → PostgreSQL

## Validation

- Pods healthy
- Services reachable
- Ingress functional
- Database persistence verified

## Result

Successfully deployed a three-tier application managed through ArgoCD GitOps.