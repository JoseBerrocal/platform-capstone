# POC19 – Capacity Planning & Scaling

## Stage 1 – Resource Sizing & Baseline

### Objective

Establish a baseline for Kubernetes resource consumption before implementing autoscaling.

### Configuration

| Workload   | Replicas | CPU Request | CPU Limit | Memory Request | Memory Limit |
| ---------- | -------: | ----------: | --------: | -------------: | -----------: |
| Client     |        2 |        100m |      300m |          128Mi |        256Mi |
| Server     |        3 |        200m |      500m |          256Mi |        512Mi |
| PostgreSQL |        1 |        200m |      500m |          256Mi |        512Mi |

### Validation

* Configured resource requests and limits.
* Verified Metrics Server.
* Captured node utilization.
* Captured pod utilization.
* Verified deployment configuration.
* Established baseline resource consumption.

### Operational Improvement

Resolved a PostgreSQL `CrashLoopBackOff` caused by non-root filesystem permissions by updating the Helm chart to support secure persistent storage.

### Outcome

* Stable platform baseline established.
* Resource allocation verified.
* No CPU throttling observed.
* No OOMKilled events after tuning.
* Ready for **Stage 2 – Horizontal Pod Autoscaling (HPA)**.

### Evidence

```text
evidence/aws/poc19-capacity-planning/stage1-baseline/
```

## Stage 2 – Horizontal Pod Autoscaling

### Objective

Validate automatic scaling of the server workload based on CPU utilization.

### Configuration

- Workload: `server-deployment`
- HPA: `server-hpa`
- Min Replicas: 2
- Max Replicas: 6
- CPU Target: 70%

### Validation

- HPA deployed through Helm and ArgoCD.
- Load generated against `tenant-a.platform-demo.local`.
- Server replicas increased automatically under CPU load.
- Replicas scaled from 2 to 5 during the test.
- Replicas returned to 2 after the load ended.
- HPA also deployed successfully for tenant-b.

### Outcome

Stage 2 confirmed that the platform can automatically scale stateless API workloads using Kubernetes Horizontal Pod Autoscaler.

### Evidence

```text
evidence/aws/poc19-capacity-planning/stage2-hpa/
```

