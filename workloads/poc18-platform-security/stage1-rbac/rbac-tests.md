# POC18 Stage 1 — RBAC Tests

## Objective

Validate multi-tenant RBAC controls for the POC18 security platform.

## Tenants

* poc18-security-tenant-a
* poc18-security-tenant-b

---

## Apply RBAC Manifests

```bash
kubectl apply -f workloads/poc18-platform-security/stage1-rbac/developer-role-tenant-a.yaml
kubectl apply -f workloads/poc18-platform-security/stage1-rbac/readonly-role-tenant-a.yaml
kubectl apply -f workloads/poc18-platform-security/stage1-rbac/developer-rolebinding-tenant-a.yaml
kubectl apply -f workloads/poc18-platform-security/stage1-rbac/readonly-rolebinding-tenant-a.yaml

kubectl apply -f workloads/poc18-platform-security/stage1-rbac/developer-role-tenant-b.yaml
kubectl apply -f workloads/poc18-platform-security/stage1-rbac/readonly-role-tenant-b.yaml
kubectl apply -f workloads/poc18-platform-security/stage1-rbac/developer-rolebinding-tenant-b.yaml
kubectl apply -f workloads/poc18-platform-security/stage1-rbac/readonly-rolebinding-tenant-b.yaml
```

---

## Developer Role

Developer users can manage application resources only inside their assigned tenant namespace.

Validated:

* developer-user-a can create deployments in poc18-security-tenant-a
* developer-user-a cannot create deployments in poc18-security-tenant-b
* developer-user-b can create deployments in poc18-security-tenant-b
* developer-user-b cannot create deployments in poc18-security-tenant-a
* developer users cannot delete namespaces

---

## ReadOnly Role

ReadOnly users can inspect resources but cannot modify them.

Validated:

* readonly-user-a can get pods in poc18-security-tenant-a
* readonly-user-a cannot create deployments in poc18-security-tenant-a
* readonly-user-b can get pods in poc18-security-tenant-b
* readonly-user-b cannot create deployments in poc18-security-tenant-b

---

## Manual Validation Commands

```bash
echo "Developer A create deployment in tenant-a:"
kubectl auth can-i create deployment --as=developer-user-a -n poc18-security-tenant-a

echo
echo "Developer A create deployment in tenant-b:"
kubectl auth can-i create deployment --as=developer-user-a -n poc18-security-tenant-b

echo
echo "Developer B create deployment in tenant-b:"
kubectl auth can-i create deployment --as=developer-user-b -n poc18-security-tenant-b

echo
echo "Developer B create deployment in tenant-a:"
kubectl auth can-i create deployment --as=developer-user-b -n poc18-security-tenant-a

echo
echo "Readonly A get pods in tenant-a:"
kubectl auth can-i get pods --as=readonly-user-a -n poc18-security-tenant-a

echo
echo "Readonly A create deployment in tenant-a:"
kubectl auth can-i create deployment --as=readonly-user-a -n poc18-security-tenant-a

echo
echo "Readonly B get pods in tenant-b:"
kubectl auth can-i get pods --as=readonly-user-b -n poc18-security-tenant-b

echo
echo "Readonly B create deployment in tenant-b:"
kubectl auth can-i create deployment --as=readonly-user-b -n poc18-security-tenant-b

echo
echo "Developer A delete namespace:"
kubectl auth can-i delete namespace --as=developer-user-a
```

---

## Expected Results

```text
Developer A create deployment in tenant-a:
yes

Developer A create deployment in tenant-b:
no

Developer B create deployment in tenant-b:
yes

Developer B create deployment in tenant-a:
no

Readonly A get pods in tenant-a:
yes

Readonly A create deployment in tenant-a:
no

Readonly B get pods in tenant-b:
yes

Readonly B create deployment in tenant-b:
no

Developer A delete namespace:
no
```

---

## Platform Security Concepts

* RBAC
* Authorization
* Least Privilege
* Multi-Tenant Kubernetes
* Developer Self-Service
* Platform Governance
* Namespace Isolation
* Access Control Validation

```
```
