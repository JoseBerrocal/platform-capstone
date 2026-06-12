# Platform Operations

This document contains operational procedures used to deploy, access, validate, and remove the Platform Capstone environment.

## ArgoCD Installation

Install ArgoCD:

```bash
./bootstrap/install-argocd.sh
```

Verify installation:

```bash
kubectl get pods -n argocd
```

Retrieve the initial admin password:

```bash
kubectl get secret argocd-initial-admin-secret \
  -n argocd \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

Deploy the root application:

```bash
kubectl apply -f root-app.yaml
```

Verify applications:

```bash
kubectl get applications -n argocd
```

---

## GitOps Deployment Order

The platform uses the App-of-Apps pattern.

Deployment order:

```text
ingress-nginx
metrics-server
observability
tenant applications
```

Verify synchronization:

```bash
kubectl get applications -n argocd
```

---

## Local DNS Configuration

### Local Kubernetes

Add to `/etc/hosts`:

```text
127.0.0.1 argocd.local
127.0.0.1 grafana.local
127.0.0.1 prometheus.local
127.0.0.1 platform-demo.local
```

### AKS

Obtain the ingress public IP:

```bash
kubectl get svc -n ingress-nginx
```

Example:

```text
135.225.240.167
```

Add:

```text
135.225.240.167 tenant-a.platform-demo.local
135.225.240.167 tenant-b.platform-demo.local
135.225.240.167 argocd.local
135.225.240.167 grafana.local
135.225.240.167 prometheus.local
```

---

## Application Access

### Tenant A

```text
http://tenant-a.platform-demo.local
```

### Tenant B

```text
http://tenant-b.platform-demo.local
```

---

## ArgoCD Access

```text
http://argocd.local
```

---

## Grafana Access

```text
http://grafana.local
```

Default credentials:

```text
admin
admin123
```

---

## Prometheus Access

```text
http://prometheus.local
```

---

## Validation

Verify applications:

```bash
kubectl get applications -n argocd
```

Verify workloads:

```bash
kubectl get pods -A
```

Verify ingress:

```bash
kubectl get ingress -A
```

Verify metrics:

```bash
kubectl top nodes
kubectl top pods -A
```

Verify tenant controls:

```bash
kubectl get resourcequota -A
kubectl get limitrange -A
kubectl get networkpolicy -A
```

---

## Cleanup

Delete the root application:

```bash
kubectl delete -f root-app.yaml
```

Delete ArgoCD:

```bash
kubectl delete namespace argocd
```

Delete platform namespaces:

```bash
kubectl delete namespace ingress-nginx
kubectl delete namespace observability
kubectl delete namespace poc10-aks-tenant-a
kubectl delete namespace poc10-aks-tenant-b
```

### AWS

```bash
cd terraform/aws
terraform destroy
```

### Azure

```bash
cd terraform/azure
terraform destroy
```
