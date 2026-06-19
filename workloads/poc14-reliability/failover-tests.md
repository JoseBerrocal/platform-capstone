# POC14 — Failover Tests

## Stage 1 — Stateless Application Failover

### Environment

Local Kubernetes Cluster

Namespace:

```text
poc14-reliability-tenant-a
```

### Configuration

Client replicas: 2

Server replicas: 3

### Test

One server pod was deleted manually.

### Observation

Kubernetes immediately created a replacement pod.

Service endpoints remained available during pod replacement.

Application availability was maintained throughout the test.

### Result

Deployment automatically returned to the desired replica count.

### Conclusion

Replication and Kubernetes self-healing provide resilience for stateless workloads.

---

## Stage 2 — EKS PostgreSQL HA Failover

### Environment

AWS EKS

Namespace:

```text
postgres-ha
```

CloudNativePG Cluster:

```text
postgres-ha
```

Instances:

```text
3
```

### Initial State

The CloudNativePG cluster was healthy with three PostgreSQL instances.

One instance was acting as primary and the remaining instances were replicas.

Application-generated data already existed in the database and was used for validation.

### Test

The primary PostgreSQL pod was identified and manually deleted.

```text
Primary deleted
↓
CloudNativePG detected failure
↓
Replica promoted
↓
New replica created
↓
Cluster returned to healthy state
```

### Observation

A replica was promoted automatically to primary.

CloudNativePG reconciled the cluster and restored the desired instance count.

Database availability was maintained during recovery.

### Data Validation

Database tables and application data remained available after failover.

The same data visible before failover remained accessible from the new primary instance.

### Result

Primary failover completed successfully.

Replication functioned correctly.

Persistent storage remained intact.

Cluster health returned to normal automatically.

### Concepts Demonstrated

* Replication
* Primary / Replica Architecture
* Automated Failover
* Leader Election
* Operator Reconciliation
* Persistent Storage Recovery
* High Availability Databases

### Conclusion

CloudNativePG provides PostgreSQL high availability through replication, automated failover, and operator-driven reconciliation. The cluster successfully recovered from primary node loss while preserving application data.
