# POC14 - Reliability, Observability & Alerting (EKS)

## Objective

Validate reliability monitoring and alerting capabilities on the EKS platform using Prometheus, Grafana and CloudNativePG.

The goal of this stage was to demonstrate:

- Platform observability
- Custom Prometheus alerting
- Incident detection
- Incident recovery
- PostgreSQL HA health monitoring

---

## Environment

Platform Components:

- Amazon EKS
- ArgoCD
- Prometheus Operator
- Grafana
- Alertmanager
- CloudNativePG
- Multi-tenant applications

Namespaces:

- observability
- postgres-ha
- poc14-reliability-tenant-a
- poc14-reliability-tenant-b

---

## Custom Alert Rules

Implemented:

### DeploymentReplicasMismatch

Detects deployments with fewer available replicas than desired replicas.

### PodRestartingFrequently

Detects containers restarting repeatedly.

### PostgreSQLClusterDegraded

Detects PostgreSQL monitoring degradation.

---

## Incident Simulation

A controlled deployment failure was created by deploying an invalid container image.

Observed behavior:

- New pod entered ImagePullBackOff state
- Deployment became degraded
- Available replicas became lower than desired replicas
- Prometheus detected the condition
- DeploymentReplicasMismatch alert fired successfully

---

## Validation Results

Validated:

- PrometheusRule deployment
- Prometheus Operator rule validation
- Prometheus alert evaluation
- Deployment degradation detection
- Alert firing confirmation
- Deployment recovery validation
- PostgreSQL cluster health verification

Not validated:

- PodRestartingFrequently alert
- PostgreSQLClusterDegraded alert

These alerts were defined but not intentionally triggered during this stage.

PostgreSQL primary failover, leader election, and data persistence validation were successfully completed during Stage 2.

---

## Evidence

Location:

evidence/aws/poc14-reliability/stage3-eks-observability/

Key evidence:

- deployment-broken.txt
- deployment-recovered.txt
- pods-imagepullbackoff.txt
- postgres-cluster-status.txt
- prometheus-rules-validation.txt
- prometheus-expression-firing.png
- prometheus-alert-firing.png

---

## Outcome

The platform successfully detected and reported deployment degradation through Prometheus alerting.

This stage validated the observability and alerting foundations required for the next reliability phase involving PostgreSQL failover testing.