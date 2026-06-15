# POC12 - Recovery Notes

## Lessons Learned

* Git is the source of truth.
* Manual cluster changes create drift.
* ArgoCD detects drift automatically.
* Reconciliation restores the desired state.

## Recovery Workflow

1. Detect OutOfSync application.
2. Compare Git and cluster state.
3. Identify manual change.
4. Execute ArgoCD sync.
5. Verify Healthy and Synced state.

## Key Commands

```bash
kubectl get applications -n argocd

argocd app get APP_NAME

argocd app sync APP_NAME
```

## Takeaways

* Avoid manual production changes.
* All changes should originate from Git.
* GitOps provides auditability and repeatability.
