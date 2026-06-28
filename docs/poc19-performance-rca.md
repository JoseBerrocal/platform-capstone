# POC19 – Performance RCA

## Overview

This document summarizes the performance failure scenarios executed during POC19 Phase 4.

The objective was to intentionally stress the platform, observe failure symptoms, recover using GitOps-managed configuration, and document tuning recommendations.

Tested scenarios:

- CPU saturation
- Memory exhaustion
- Excessive traffic

Evidence:

```text
evidence/aws/poc19-capacity-planning/stage4-failure-scenarios/
```

---

## Test Environment

### Platform

- Kubernetes: AWS EKS
- GitOps: ArgoCD
- Ingress: NGINX Ingress Controller
- Monitoring: Prometheus & Grafana
- Autoscaling: Horizontal Pod Autoscaler (HPA)
- Load Generator: hey

### Workloads

- Tenant A
- Tenant B
- Shared CloudNativePG PostgreSQL database

---

# Scenario 1 – CPU Saturation

## Goal

Validate HPA behavior when CPU becomes the primary bottleneck.

### Impact

Server workloads experienced CPU pressure after reducing CPU limits and generating sustained traffic.

Both tenant server deployments reached the maximum HPA replica count.

### Detection

CPU saturation was detected through HPA metrics and pod resource usage.

Observed HPA status:

| Tenant | CPU Target | Observed CPU | Replicas |
| ------- | ---------: | -----------: | -------: |
| Tenant A | 70% | 121% | 6 |
| Tenant B | 70% | 144% | 6 |

### Root Cause

The server CPU limit was intentionally reduced below the normal production configuration.

Under load, the server containers reached CPU saturation, causing the HPA to scale both deployments to the configured maximum of six replicas.

### Resolution

The original CPU limits were restored through the tenant Helm values and reconciled by ArgoCD.

After synchronization completed, both server deployments returned to their normal operating state.

### Tuning Recommendations

- Keep CPU limits aligned with observed production workloads.
- Avoid configuring CPU limits too close to normal operating usage.
- Consider increasing `maxReplicas` if sustained CPU utilization consistently exceeds the HPA target.
- Review HPA target utilization based on production traffic patterns.
- Continue monitoring CPU throttling during higher-concurrency testing.

---

# Scenario 2 – Memory Exhaustion

## Goal

Validate Kubernetes recovery behavior when workloads exceed configured memory limits.

### Impact

Server pods entered `CrashLoopBackOff` after memory limits were intentionally reduced.

Both tenant workloads experienced `OOMKilled` events.

### Detection

Memory exhaustion was identified through pod status, restart counts, and `kubectl describe pod`.

Observed failure evidence:

| Tenant | Memory Limit | Pod State | Last Termination Reason | Exit Code | Restart Count |
| ------- | -----------: | ---------------- | ----------------------- | --------: | ------------: |
| Tenant A | 80Mi | CrashLoopBackOff | OOMKilled | 137 | 5 |
| Tenant B | 96Mi | CrashLoopBackOff | OOMKilled | 137 | 5 |

### Root Cause

The configured memory limits were intentionally reduced below the application's runtime requirements.

As memory consumption exceeded the configured limits, Kubernetes terminated the containers with exit code 137 (`OOMKilled`).

### Resolution

The original Helm values were restored and synchronized through ArgoCD.

After reconciliation, both deployments recovered automatically and returned to a healthy state.

### Tuning Recommendations

- Never configure memory limits below observed runtime consumption.
- Use baseline measurements collected during normal operation when defining production limits.
- Reserve sufficient memory headroom for traffic spikes and garbage collection.
- Monitor `OOMKilled` events and restart counts through Prometheus alerts.
- Consider memory-based autoscaling only if memory becomes a consistent bottleneck.

---

# Scenario 3 – Excessive Traffic

## Goal

Measure platform behavior under sustained concurrent traffic while evaluating autoscaling effectiveness and service stability.

### Impact

Both tenants received sustained high-concurrency traffic using **hey** with 300 concurrent clients for 10 minutes.

The platform remained available but exhibited increased latency together with a small number of HTTP 502/504 responses.

### Detection

Performance degradation was observed through load-test metrics, HPA status, and Grafana dashboards.

Observed HPA status:

| Tenant | CPU Target | Observed CPU | Replicas |
| ------- | ---------: | -----------: | -------: |
| Tenant A | 70% | 90% | 6 |
| Tenant B | 70% | 92% | 6 |

Observed load-test behavior:

| Tenant | Throughput | Average Latency | P99 Latency | Slowest Response | Error Pattern |
| ------- | -----------------: | --------------: | ----------: | ---------------: | ------------- |
| Tenant A | ~1,820–1,883 req/s | ~180 ms | ~333–371 ms | ~5.2–5.5 s | Low 502/504 |
| Tenant B | ~1,829–1,918 req/s | ~180 ms | ~332–369 ms | ~1.6–5.4 s | Low 502/504 |

### Root Cause

The platform was intentionally stressed beyond the previous performance baseline.

Both HPA controllers successfully scaled the server deployments to the configured maximum of six replicas. Once the scaling limit was reached, additional traffic pressure resulted in increased response latency and occasional ingress-level HTTP 502/504 responses.

### Resolution

No manual intervention was required.

After traffic generation stopped, CPU utilization decreased and the HPA automatically scaled the workloads back to their steady-state replica count.

### Tuning Recommendations

- Increase `maxReplicas` if higher sustained concurrency is required.
- Validate node capacity before increasing HPA limits.
- Consider enabling Cluster Autoscaler to dynamically expand node capacity.
- Add application-level Prometheus metrics for request rate, latency, and error rate.
- Investigate ingress controller logs to determine the source of HTTP 502/504 responses.
- Execute longer endurance tests to validate long-term platform stability.

---

# Final Assessment

The platform successfully demonstrated resilient behavior across all planned failure scenarios.

Key observations:

- HPA correctly reacted to CPU pressure and scaled workloads to the configured maximum of six replicas.
- Kubernetes correctly enforced memory limits by terminating containers with `OOMKilled` when memory constraints were exceeded.
- GitOps-based recovery restored the platform to its production configuration without manual operational changes.
- Sustained traffic of approximately **1,900 requests per second per tenant** was handled with acceptable latency, while only a small percentage of requests resulted in HTTP 502/504 responses after HPA reached its configured scaling limit.

Future improvements include:

- Cluster Autoscaler integration.
- Vertical Pod Autoscaler evaluation.
- Additional application-level Prometheus metrics.
- Stress testing beyond six replicas.
- Long-duration endurance testing.

---

# Lessons Learned

- Resource requests and limits have a direct impact on workload stability and platform resilience.
- Proper HPA thresholds are essential for balancing latency, throughput, and infrastructure utilization.
- Memory limits should always include operational headroom to prevent unnecessary `OOMKilled` events.
- Capacity planning should combine synthetic load testing with production monitoring data.
- GitOps provides fast, repeatable, and reliable recovery after configuration changes.