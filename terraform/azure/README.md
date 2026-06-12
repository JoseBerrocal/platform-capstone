## AKS Workload Identity

The cluster enables OIDC and Azure Workload Identity.

```hcl
oidc_issuer_enabled       = true
workload_identity_enabled = true
```

This provides the Azure equivalent of AWS IRSA and allows Kubernetes ServiceAccounts to authenticate to Azure resources without storing credentials inside pods.

---

## Platform Components

This infrastructure deploys:

- Resource Group
- Virtual Network
- AKS Cluster
- Azure Container Registry (ACR)
- Managed Identity
- Azure Workload Identity
- Custom StorageClass
- API Server IP Restrictions

### Validation:

```bash
kubectl get nodes
kubectl get storageclass
az acr list -o table
```

---

## Troubleshooting

### 1. Show only families with quota

```bash
az vm list-usage --location swedencentral \
  --query "[?limit > \`0\` && contains(name.localizedValue, 'Family')].[name.localizedValue,limit]" \
  -o table
```

### 2. Pick a small size from a family with quota

Since you found **Dv4 = 10**, check small Dv4 sizes:

```bash
az vm list-skus --location swedencentral --resource-type virtualMachines \
  --query "[?starts_with(name,'Standard_D2') && contains(name,'v4')].name" \
  -o table
```

### 3. Put one result in Terraform

```hcl
aks_node_size = "Standard_D2_v4"
```

That’s the shortest practical flow:  
**quota family → matching small VM size → Terraform.**

---

## StorageClass Ownership

AKS creates several built-in StorageClasses automatically:

```bash
kubectl get storageclass
```

Example:

```text
default
managed
managed-csi
managed-csi-premium
azurefile
azurefile-csi
...
```

The platform creates and manages its own StorageClass:

```text
managed-csi-platform
```

Terraform resource:

```hcl
resource "kubernetes_storage_class_v1" "managed_csi" {
  metadata {
    name = "managed-csi-platform"

    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner    = "disk.csi.azure.com"
  reclaim_policy         = "Delete"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true

  parameters = {
    skuName = "StandardSSD_LRS"
  }
}
```

### Make the platform StorageClass the default

AKS marks its built-in `default` StorageClass as default.

After cluster creation:

```bash
kubectl annotate storageclass default \
  storageclass.kubernetes.io/is-default-class="false" --overwrite
```

Verify:

```bash
kubectl get storageclass
```

Expected:

```text
managed-csi-platform (default)
```

This demonstrates platform ownership of the default storage policy instead of relying on AKS defaults.

---

## Azure LoadBalancer Troubleshooting

**Issue:**  
- DNS worked  
- Ingress worked internally  
- External access to LoadBalancer IP hung

**Fix:**

```bash
kubectl patch svc ingress-nginx-controller \
  -n ingress-nginx \
  -p '{"spec":{"externalTrafficPolicy":"Local"}}'
```

**Result:**

```text
Azure LoadBalancer started routing traffic correctly
Applications became accessible through ingress hostnames
```