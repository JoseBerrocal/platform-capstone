# POC12 - GitOps Drift Recovery

## Incident

A deployment was modified directly in the cluster.

## Symptoms

* Application OutOfSync
* Cluster state differed from Git

## Investigation

```bash
kubectl get applications -n argocd

kubectl get deployment client-deployment \
  -n poc12-tenant-a
```

## Root Cause

Manual change applied outside Git:

```text
replicas: 1 -> replicas: 5
```

## Recovery

ArgoCD synchronization restored the desired state.

```bash
argocd app sync poc12-tenant-a-oci
```

## Validation

```bash
kubectl get applications -n argocd

kubectl get deployment client-deployment \
  -n poc12-tenant-a
```

Result:

```text
Healthy
Synced
Replicas restored to Git value
```
