# POC18 — Security Incident RCA

## Overview

This document summarizes security-related incidents simulated on the POC18 multi-tenant Kubernetes platform running on Amazon EKS.

The objective was to practice incident response, troubleshooting, root cause analysis, recovery procedures, and preventative controls.

---

# Incident 1 — Missing Secret

## Impact

The application in tenant-b could not start because required database credentials were unavailable.

Affected Namespace:

```text
poc18-security-tenant-b
```

Affected Component:

```text
server-deployment
```

---

## Detection

The workload failed during startup.

Observed Symptoms:

```text
CreateContainerConfigError
Secret not found
```

Investigation Commands:

```bash
kubectl get pods -n poc18-security-tenant-b
kubectl describe pod POD_NAME -n poc18-security-tenant-b
kubectl get secrets -n poc18-security-tenant-b
```

---

## Root Cause

The PostgreSQL credential Secret was accidentally deleted.

Missing Secret:

```text
pgpassword
```

The deployment referenced the Secret through environment variables and could not initialize without it.

---

## Resolution

The Secret was restored through the GitOps workflow.

Recovery:

```bash
argocd app sync poc18-security-tenant-b-oci
```

The Secret was recreated and the workload successfully started.

---

## Prevention

* Store platform secrets in GitOps-managed configuration.
* Use automated reconciliation through ArgoCD.
* Implement secret monitoring and alerting.
* Consider External Secrets Operator or AWS Secrets Manager for centralized secret management.

---

# Incident 2 — NetworkPolicy Enforcement Gap

## Impact

A network segmentation validation test produced unexpected results.

Traffic between workloads remained functional even when a NetworkPolicy intended to restrict communication was removed.

Affected Namespace:

```text
poc18-security-tenant-b
```

Affected Component:

```text
server-deployment
postgres-deployment
```

---

## Detection

Network connectivity tests continued to succeed after removal of the NetworkPolicy.

Validation Commands:

```bash
kubectl get netpol -n poc18-security-tenant-b

kubectl exec POD_NAME -- \
nc -zv postgres-cluster-ip-service 5432
```

Observed Result:

```text
Connection remained open.
```

---

## Root Cause

The NetworkPolicy was correctly defined and deployed.

However, the cluster CNI implementation was not enforcing Kubernetes NetworkPolicy resources.

As a result, NetworkPolicy objects existed in the cluster but traffic was not filtered.

---

## Resolution

The NetworkPolicy configuration was restored through GitOps synchronization.

Recovery:

```bash
argocd app sync poc18-security-tenant-b-oci
```

Validation confirmed that the expected policy configuration was present.

---

## Prevention

* Verify NetworkPolicy enforcement during cluster onboarding.
* Validate security controls using connectivity tests.
* Enable AWS VPC CNI Network Policy support when using Amazon EKS.
* Alternatively deploy a policy-capable CNI such as Calico or Cilium.
* Include NetworkPolicy validation in platform acceptance testing.

---

# Incident 3 — Pod Security Admission Violation

## Impact

A workload attempting to run with elevated privileges was rejected by the platform security controls.

Affected Namespace:

```text
poc18-security-tenant-a
```

Affected Component:

```text
privileged-pod-test
```

---

## Detection

The workload failed during admission.

Validation Command:

```bash
kubectl apply -f privileged-pod.yaml
```

Observed Result:

```text
Error from server (Forbidden)
```

---

## Root Cause

The Pod attempted to violate the restricted Pod Security Admission policy.

Violations included:

* privileged=true
* allowPrivilegeEscalation enabled
* runAsNonRoot missing
* seccompProfile missing
* unrestricted Linux capabilities

The namespace was configured with:

```text
pod-security.kubernetes.io/enforce=restricted
```

which prevented deployment of the insecure workload.

---

## Resolution

The insecure workload was rejected before deployment.

No remediation was required because the security controls functioned as designed.

---

## Prevention

* Enforce Pod Security Admission restricted policies for all tenant namespaces.
* Provide secure Helm chart defaults.
* Validate workload security settings during development.
* Use admission controls to prevent insecure workloads from reaching production.

---

# Lessons Learned

The platform successfully demonstrated multiple layers of defense:

* RBAC-based access control
* Workload identity through Service Accounts
* Network segmentation policies
* Secret management controls
* Secure workload defaults
* Pod Security Admission enforcement

The incidents highlighted the importance of validating not only configuration but also runtime enforcement of security controls.

Particular attention should be given to verifying NetworkPolicy enforcement capabilities of the cluster CNI implementation during platform onboarding.
