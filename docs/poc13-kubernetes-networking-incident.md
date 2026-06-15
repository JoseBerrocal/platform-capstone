# POC13 — Kubernetes Networking Incident

## Objective

Practice production-grade Kubernetes networking troubleshooting by intentionally introducing failures across multiple networking layers and recovering the platform using Kubernetes and ArgoCD.

The exercise focuses on:

* Services
* Endpoints
* Ingress
* NetworkPolicy
* GitOps-based recovery

---

## Environment

Platform:

* Kubernetes (local cluster)
* ArgoCD
* Helm OCI deployment
* Tenant namespace: `poc12-tenant-a`

Application flow:

```text
Ingress
   ↓
Service
   ↓
Endpoints
   ↓
Pod
   ↓
PostgreSQL
```

---

## Incident 1 — Broken Service Selector

### Failure

Modified the Service selector for:

```text
server-cluster-ip-service
```

Changed:

```yaml
selector:
  component: server
```

to:

```yaml
selector:
  component: wrong-server
```

### Impact

The Service could no longer match the server Pods.

### Investigation

Commands used:

```bash
kubectl get endpoints -n poc12-tenant-a
kubectl describe svc server-cluster-ip-service -n poc12-tenant-a
kubectl get pods -n poc12-tenant-a --show-labels
```

### Findings

* Service selector did not match Pod labels.
* Endpoints object contained no backend endpoints.

### Recovery

```bash
argocd app sync poc12-tenant-a-oci
```

### Validation

Endpoints were recreated and traffic routing was restored.

---

## Incident 2 — Broken Ingress Backend

### Failure

Modified the Ingress backend service reference.

Changed:

```yaml
name: server-cluster-ip-service
```

to:

```yaml
name: wrong-service
```

### Impact

Ingress could not route API requests to the backend Service.

### Investigation

Commands used:

```bash
kubectl describe ingress ingress-service -n poc12-tenant-a
kubectl get svc -n poc12-tenant-a
kubectl get endpoints -n poc12-tenant-a
```

### Findings

Ingress reported:

```text
services "wrong-service" not found
```

### Recovery

```bash
argocd app sync poc12-tenant-a-oci
```

### Validation

Ingress backend reference was restored and routing resumed.

---

## Incident 3 — NetworkPolicy Egress Block

### Failure

Applied a deny-all egress policy targeting server Pods.

### Impact

Server Pods were prevented from initiating outbound network connections.

### Investigation

Commands used:

```bash
kubectl get networkpolicy -n poc12-tenant-a
kubectl describe networkpolicy deny-server-egress -n poc12-tenant-a
kubectl logs deployment/server-deployment -n poc12-tenant-a
```

### Findings

The policy isolated server Pods for egress traffic.

### Recovery

```bash
kubectl delete -f workloads/poc13-networking/networkpolicy.yaml
```

### Validation

Normal network communication was restored.

---

## Lessons Learned

* Services depend entirely on matching Pod labels.
* Endpoints are the first resource to inspect when a Service appears unhealthy.
* Ingress failures are frequently caused by incorrect backend Service references.
* NetworkPolicies can silently block application communication.
* ArgoCD provides a reliable recovery mechanism when Git remains the source of truth.
* Troubleshooting should follow the request path:

```text
Ingress
   ↓
Service
   ↓
Endpoints
   ↓
Pod
```

---

## Result

Successfully simulated and recovered three common Kubernetes networking incidents while preserving GitOps operational practices.
