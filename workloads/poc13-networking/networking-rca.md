# POC13 — Kubernetes Networking Incident RCA

## Incident 1: Broken Service selector

Root cause: Service selector did not match pod labels.

Impact: server-cluster-ip-service had no endpoints, so traffic could not reach server pods.

Evidence:
- server-cluster-ip-service showed no endpoints.
- Service selector was component=wrong-server.
- Server pod label was component=server.

Recovery: ArgoCD sync restored the correct Service selector.

## Incident 2: Broken Ingress backend

Root cause: Ingress referenced an invalid backend Service.

Impact: Ingress could not route /api traffic to the server Service.

Evidence:
- Ingress backend showed wrong-service:5000.
- Kubernetes reported services "wrong-service" not found.

Recovery: ArgoCD sync restored the correct Ingress backend.

## Incident 3: NetworkPolicy blocked server egress

Root cause: A deny-all egress NetworkPolicy was applied to server pods.

Impact: Server pods were isolated for egress connectivity and could not initiate outbound traffic.

Evidence:
- deny-server-egress selected component=server pods.
- Policy allowed no egress traffic.

Recovery: Removed the deny-server-egress NetworkPolicy.
