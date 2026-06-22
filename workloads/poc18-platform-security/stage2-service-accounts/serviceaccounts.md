# POC18 Stage 2 — Service Accounts & Workload Identity

## Objective

Replace default workload identity with dedicated ServiceAccounts and validate least-privilege workload permissions across both POC18 tenants.

## Tenant A

Workloads:

- client-deployment
- server-deployment

ServiceAccounts:

- client-sa
- server-sa

## Tenant B

Workloads:

- client-deployment
- server-deployment
- postgres-deployment

ServiceAccounts:

- client-sa
- server-sa
- postgres-sa

## Implemented

- Dedicated ServiceAccounts per workload type
- server-configmap-reader Role in tenant-a
- server-configmap-reader Role in tenant-b
- server-configmap-reader RoleBinding in tenant-a
- server-configmap-reader RoleBinding in tenant-b
- Helm chart support for assigning ServiceAccounts through tenant values

## Validation

Validated:

- Tenant A client pods use client-sa
- Tenant A server pods use server-sa
- Tenant B client pods use client-sa
- Tenant B server pods use server-sa
- Tenant B postgres pod uses postgres-sa
- server-sa can read ConfigMaps in its own namespace
- server-sa cannot create Deployments
- client-sa cannot read ConfigMaps
- postgres-sa does not receive unnecessary ConfigMap permissions

## Least Privilege Design

Only server workloads receive Kubernetes API permissions.

RoleBindings were intentionally created only for:

* server-sa in tenant-a
* server-sa in tenant-b

No RoleBindings were created for:

* client-sa
* postgres-sa

Reason:

* client workloads do not need Kubernetes API access
* postgres workloads do not need Kubernetes API access

This validates the least-privilege principle by granting permissions only to workloads that require them.

## Concepts

- Service Accounts
- Workload Identity
- Token-based authentication
- Least privilege
- Workload-level RBAC
- Tenant isolation
- GitOps-managed identity configuration
