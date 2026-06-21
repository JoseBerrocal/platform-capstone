# POC14 — Reliability RCA

## Summary

POC14 validated reliability patterns across stateless applications, stateful PostgreSQL HA, and observability on AWS EKS.

The POC covered:

- Stateless application failover
- PostgreSQL HA with CloudNativePG
- EBS-backed stateful recovery
- Prometheus alerting
- SLI/SLO definitions
- Production-style RCA

---

## Stage 1 — Stateless Application Failover

### Incident

One server pod was deleted manually.

### Impact

Application availability was maintained because multiple server replicas were running.

### Recovery

Kubernetes recreated the deleted pod automatically.

### Result

The deployment returned to the desired replica count and Service endpoints remained available.

### Lesson Learned

Stateless workloads achieve resilience through replicas, Services, and Kubernetes self-healing.

---

## Stage 2 — EKS PostgreSQL HA Failover

### Incident

The primary PostgreSQL pod was deleted to simulate database failure.

### Impact

CloudNativePG promoted a replica to primary through automated leader election.

The PostgreSQL cluster temporarily stayed at 2/3 ready instances because the replacement PostgreSQL pod could not be scheduled.

### Root Cause

The replacement pod required an EBS volume located in `eu-west-1b`.

The available node in `eu-west-1b` did not have enough pod capacity.

Kubernetes scheduling failed because of:

- PersistentVolume node affinity
- Pod capacity exhaustion

### Resolution

The EKS node group capacity was increased.

AWS created an additional worker node in `eu-west-1b`.

Kubernetes scheduled the replacement PostgreSQL pod successfully.

### Result

The PostgreSQL cluster returned to 3/3 ready instances and healthy status.

### Lesson Learned

Database high availability depends on more than replication and failover.

It also depends on:

- Storage topology
- Availability Zones
- Node capacity
- Kubernetes scheduling
- Operator reconciliation

---

## Stage 3 — Reliability Observability

### Incident Tested

The server deployment was intentionally degraded to trigger a reliability alert.

### Detection

Prometheus rules were created and validated by the Prometheus Operator.

The `DeploymentReplicasMismatch` alert fired successfully.

### Recovery

The deployment was restored and returned to healthy state.

### Result

Prometheus alerting successfully detected application degradation.

### Lesson Learned

Reliability requires both recovery mechanisms and observability.

SLIs, SLOs, error budgets, and alerts make platform reliability measurable.

---

## Final Conclusion

POC14 demonstrated that production reliability requires multiple layers:

- Application replicas for stateless availability
- CloudNativePG replication for database HA
- EBS-backed persistent storage
- Enough node capacity in the correct Availability Zone
- Prometheus alerting for detection
- RCA documentation for operational learning

The most important finding was that PostgreSQL failover and leader election succeeded automatically, but full cluster recovery depended on cloud infrastructure capacity and storage topology.

This demonstrates that high availability is not achieved solely through application or database replication. Production reliability also requires sufficient compute capacity, storage availability, observability, and automated recovery mechanisms.