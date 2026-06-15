# POC11 - Recovery Notes

## Lessons Learned

* PVCs depend on valid StorageClasses.
* Storage failures often appear as application failures.
* Always create a backup before destructive actions.
* Validate data after recovery.

## Key Commands

```bash
kubectl describe pvc PVC_NAME

kubectl get events --sort-by=.metadata.creationTimestamp

kubectl get storageclass

kubectl get pods

kubectl get pvc
```

## Takeaways

* Investigate PVCs before pods.
* Check events for root cause.
* Recovery must include data validation.
* GitOps provides an auditable recovery workflow.
