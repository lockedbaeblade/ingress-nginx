# Target Environment Inventory

**Status:** TEMPLATE — do not deploy until completed and reviewed.  
**Handling:** Do not commit credentials, Secret values, kubeconfig, private keys, presigned URLs, or personal data.

| Field | Value | Evidence / source | Owner | Status |
|---|---|---|---|---|
| Platform owner | UNKNOWN | | | OPEN |
| Application owner | UNKNOWN | | | OPEN |
| Security approver | UNKNOWN | | | OPEN |
| Rollback authority | UNKNOWN | | | OPEN |
| Provider / account boundary | UNKNOWN | | | OPEN |
| Cluster name / region | UNKNOWN | | | OPEN |
| Kubernetes version + patch | UNKNOWN | | | OPEN |
| CNI and version | UNKNOWN | | | OPEN |
| NetworkPolicy enforcement verified | UNKNOWN | | | OPEN |
| Gateway API CRD version | UNKNOWN | | | OPEN |
| Gateway controller candidate + version | UNKNOWN | | | OPEN |
| CRD lifecycle owner | UNKNOWN | | | OPEN |
| DNS provider / zone owner | UNKNOWN | | | OPEN |
| Certificate issuer / renewal owner | UNKNOWN | | | OPEN |
| Identity provider / MFA | UNKNOWN | | | OPEN |
| Container registry | UNKNOWN | | | OPEN |
| Secrets manager | UNKNOWN | | | OPEN |
| MySQL service / version | UNKNOWN | | | OPEN |
| Object storage / region | UNKNOWN | | | OPEN |
| Audit sink / retention | UNKNOWN | | | OPEN |
| Logs / metrics / traces | UNKNOWN | | | OPEN |
| Backup / restore owner | UNKNOWN | | | OPEN |
| Approved maintenance window | UNKNOWN | | | OPEN |
| Recovery objectives (RPO/RTO) | UNKNOWN | | | OPEN |

## Evidence collection rules
- Record command, tool version, timestamp with timezone, cluster context identifier, and operator.
- Export resource specifications only; do not export Secret data.
- Redact customer data, internal IPs, tokens, hostnames where sensitive, and account identifiers before sharing.
- Mark unverified assumptions as UNKNOWN.
- Obtain explicit platform-owner authorization before running read/write cluster commands.