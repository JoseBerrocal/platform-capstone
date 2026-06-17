# Stage 1 — Stateless Application Failover

## Environment

Namespace:
poc14-reliability-tenant-a

Client replicas:
2

Server replicas:
3

## Test

Deleted one server pod manually.

## Observation

Kubernetes immediately scheduled a replacement pod.

Service endpoints remained available during recovery.

Application availability was maintained.

## Result

Deployment returned automatically to the desired replica count.

## Conclusion

Replication and Kubernetes self-healing provide application-level resilience for stateless workloads.