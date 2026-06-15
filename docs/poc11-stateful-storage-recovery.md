# POC11 - Stateful Storage Recovery

## Incident

PostgreSQL PVC configured with an invalid StorageClass.

## Symptoms

* PVC Pending
* PostgreSQL unavailable

## Investigation

```bash
kubectl get pvc -n poc11-aks-tenant-a

kubectl describe pvc database-persistent-volume-claim \
  -n poc11-aks-tenant-a

kubectl get events -n poc11-aks-tenant-a
```

## Root Cause

```text
storageclass.storage.k8s.io "broken-storage" not found
```

## Recovery

Restore:

```yaml
storageClassName: managed-csi-platform
```

Sync ArgoCD and recreate PVC.

## Validation

```bash
kubectl get pvc -n poc11-aks-tenant-a

kubectl get pods -n poc11-aks-tenant-a
```

Result:

```text
PVC Bound
PostgreSQL Running
Data Restored
```
