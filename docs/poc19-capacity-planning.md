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

## Stage 3 – Load Testing & Bottleneck Analysis

### Objective

Evaluate platform behavior under sustained load, measure application performance, and identify potential bottlenecks.

### Test Configuration

| Parameter | Value |
| ---------- | ----: |
| Load Generator | hey |
| Test Duration | 10 minutes |
| Concurrent Clients | 100 |
| Target Workloads | Tenant A & Tenant B |
| HPA Range | 2–6 Replicas |
| CPU Target | 70% |

### Performance Results

| Metric | Tenant A | Tenant B |
| ------- | -------: | -------: |
| Average Throughput | ~1,650 req/s | ~1,650 req/s |
| Average Latency | ~60 ms | ~60 ms |
| P95 Latency | ~90 ms | ~90 ms |
| P99 Latency | ~136 ms | ~136 ms |
| Success Rate | >99.98% | >99.98% |
| Error Rate | <0.02% | <0.02% |

### Platform Behavior

- Horizontal Pod Autoscaler increased server replicas automatically during sustained load.
- Replica count returned to the configured minimum after CPU utilization decreased.
- CPU and memory utilization remained within configured resource limits.
- Cluster nodes remained healthy throughout the test.
- CloudNativePG remained stable while serving tenant workloads.

### Bottleneck Analysis

Observed:

- Stable throughput during the entire test.
- Low and consistent response latency.
- Very small number of HTTP 502/504 responses occurred during scaling events.
- No CPU or memory saturation observed.
- No evidence of database resource exhaustion.

### Capacity Assessment

The platform sustained approximately **1,650 requests/second per tenant** for **10 minutes** while maintaining automatic horizontal scaling and low response latency.

### Recommendations

- Increase concurrency to identify the platform saturation point.
- Execute longer endurance tests (30–60 minutes).
- Introduce CPU-intensive workloads to stress autoscaling.
- Instrument application metrics with Prometheus for detailed request and latency analysis.

### Outcome

Stage 3 validated the platform's ability to sustain production-like traffic while maintaining low latency, stable throughput, and automatic scaling through Kubernetes Horizontal Pod Autoscaler.

### Evidence

```text
evidence/aws/poc19-capacity-planning/stage3-load-testing/
```