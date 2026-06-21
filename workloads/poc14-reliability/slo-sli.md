# SLI / SLO

## Application Availability

SLI:
Successful HTTP requests / Total HTTP requests

SLO:
99.9% monthly availability

Error Budget:
43.2 minutes/month

---

## PostgreSQL Availability

SLI:
Time primary database is available and accepting connections

SLO:
99.95% monthly availability

Error Budget:
21.6 minutes/month

---

## Alerting Strategy

### DeploymentReplicasMismatch

Purpose:
Detect when a deployment has fewer available replicas than desired replicas.

Expression:

`kube_deployment_status_replicas_available < kube_deployment_spec_replicas`

Validation:
Server deployment intentionally degraded using an invalid container image, causing the alert to fire.

### PodRestartingFrequently

Purpose:
Detect containers restarting repeatedly within a short period of time.

Expression:

`increase(kube_pod_container_status_restarts_total[10m]) > 3`

Validation:
Rule defined but not triggered during this stage.

### PostgreSQLClusterDegraded

Purpose:
Detect loss of PostgreSQL cluster observability.

Expression:

`cnpg_collector_up < 1`

Validation:
Rule defined but not triggered during this stage.

---

## Reliability Validation

Validated during this stage:

- PrometheusRule created and deployed
- Prometheus Operator accepted and validated the rule
- Custom alert rules loaded into Prometheus
- Server deployment intentionally degraded
- ImagePullBackOff condition observed
- DeploymentReplicasMismatch alert fired successfully
- Alert visibility confirmed through Prometheus
- Deployment recovered after GitOps synchronization
- PostgreSQL HA cluster remained healthy during the application incident

Not validated during this stage:

- PostgreSQL primary failover
- PostgreSQL leader election behavior
- Data persistence after PostgreSQL failover
- PodRestartingFrequently alert
- PostgreSQLClusterDegraded alert