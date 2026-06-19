## Stage 2 — EKS PostgreSQL HA Failover RCA

### Incident

The primary PostgreSQL pod was deleted to simulate a database failure.

### Impact

CloudNativePG successfully promoted a replica to primary, but the cluster temporarily stayed at 2/3 ready instances because the replacement PostgreSQL pod could not be scheduled.

### Root Cause

The replacement PostgreSQL pod required an EBS volume located in `eu-west-1b`.

The only available node in `eu-west-1b` did not have enough pod capacity.

### Resolution

The EKS node group capacity was increased.

AWS created an additional worker node in `eu-west-1b`, allowing Kubernetes to schedule the replacement PostgreSQL pod.

### Result

The PostgreSQL cluster returned to 3/3 ready instances and healthy status.

### Lesson Learned

Database HA depends not only on replication and failover, but also on storage topology, availability zones, and node capacity.