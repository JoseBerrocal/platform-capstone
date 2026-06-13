# Tenant Platform Helm Chart

Reusable tenant platform used by POC10.

---

## Components

- Client  
- Server  
- PostgreSQL  
- Persistent Volume Claim (PVC)  
- ResourceQuota  
- LimitRange  
- NetworkPolicy  
- Ingress  

---

## Install Instructions

### Tenant A

```bash
helm upgrade --install tenant-a \
  charts/tenant-platform \
  -f workloads/poc10-aks/tenant-a-values.yaml
```

### Tenant B

```bash
helm upgrade --install tenant-b \
  charts/tenant-platform \
  -f workloads/poc10-aks/tenant-b-values.yaml
```

---

## OCI Distribution

The chart is published through GitHub Container Registry (GHCR).

Example command to pull the chart:  

```bash
helm pull oci://ghcr.io/JoseBerrocal/platform-capstone/tenant-platform
```

---

## Documentation Notes

You already have:  
- `docs/poc10-phase1-aks.md`  
- `docs/poc10-phase2-helm.md`

Create:  
- `docs/poc10-phase3-oci.md`

Include documentation on:  
- GHCR login  
- Helm package  
- Helm push  
- Helm pull  
- ArgoCD OCI deployment  
- Validation  
- Lessons learned

---

## Portfolio Repository Highlights

The most important updates demonstrating your workflow progression:  

- `README.md`  
- `charts/tenant-platform/README.md`  
- `docs/poc10-phase3-oci.md`

Showcasing the phases:  
- Phase 1 → AKS Multi-Tenant  
- Phase 2 → Helm Standardization  
- Phase 3 → OCI Distribution  

---