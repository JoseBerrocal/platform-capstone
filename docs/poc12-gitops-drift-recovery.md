# POC12 - GitOps Drift Recovery

## Objective

Demonstrate Git as the single source of truth using ArgoCD drift detection and reconciliation.

## Environment

* Local Kubernetes Cluster
* ArgoCD
* OCI Helm Chart
* Tenant Platform

Application:

```text
poc12-tenant-a
```

## Incident

A deployment was modified directly in the cluster.

Manual change:

```bash
kubectl scale deployment client-deployment \
  --replicas=5 \
  -n poc12-tenant-a
```

## Symptoms

ArgoCD reported:

```text
OutOfSync
```

Cluster state:

```text
replicas: 5
```

Git state:

```text
replicas: 1
```

## Investigation

Commands used:

```bash
kubectl get applications -n argocd

kubectl get deployment client-deployment \
  -n poc12-tenant-a
```

## Root Cause

A manual change was applied directly to the cluster, bypassing Git.

The live cluster state no longer matched the desired state stored in Git.

## Recovery

ArgoCD reconciliation restored the desired state.

```bash
argocd app sync poc12-tenant-a-oci
```

## Validation

Verify ArgoCD:

```bash
kubectl get applications -n argocd
```

Verify deployment:

```bash
kubectl get deployment client-deployment \
  -n poc12-tenant-a
```

Result:

```text
Healthy
Synced
replicas: 1
```

## Evidence

```text
evidence/local/poc12-gitops
```

Artifacts:

```text
applications-before.txt
applications-drift.txt
applications-recovered.txt
deployment-drift.txt
deployment-recovered.txt
```

## Outcome

Successfully detected configuration drift and restored the desired state through GitOps reconciliation.

## Concepts Demonstrated

* ArgoCD
* GitOps
* Drift Detection
* Reconciliation
* Desired State Management
* OCI Helm Deployments
