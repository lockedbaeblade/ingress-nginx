# Threat model and interim security controls

**Scope:** legacy Ingress NGINX controller fork and the proposed transition away from it.  
**Assessment status:** DESIGNED; deployment-specific verification NOT TESTED.

## Security objective

Avoid introducing or continuing an unsupported internet-facing control/data-plane component. Preserve availability while reducing exposure during a planned migration to a maintained Gateway API implementation.

## Assets

- Public hostnames, routing rules, and backend service topology.
- Kubernetes API credentials and controller ServiceAccount tokens.
- TLS private keys and referenced Kubernetes Secrets.
- Controller-generated NGINX configuration and runtime state.
- Application endpoints and request/response data.
- Container images, Helm charts, build credentials, signing keys, CI artifacts, and release metadata.
- Audit, security-event, and incident evidence.

## Trust boundaries and threat actors

| Boundary | Threat |
|---|---|
| Internet client → edge proxy | Malicious requests, protocol abuse, volumetric load, request smuggling, credential attacks |
| Kubernetes API → controller | Unauthorized or compromised writer alters routes/annotations or causes unsafe generated configuration |
| Namespace/workload → controller | A less-trusted tenant gains influence over shared routing or controller behavior |
| CI runner → artifact registry | Compromised workflow, dependency, runner, or release credential publishes a malicious image/chart |
| Operator workstation → cluster | Wrong context, over-privileged credentials, accidental production mutation |
| Logs/metrics → observability system | Credentials, cookies, headers, internal topology, or personal data leak into telemetry |

## Non-negotiable constraints

1. Do not recommend this retired controller for new production deployments.
2. Do not claim that a local fork is secure merely because it is public, writable, unarchived, signed at one commit, or has CI workflows.
3. Do not use this controller as a multi-tenant production boundary. The upstream README explicitly warns against multi-tenant production installations and states its trust assumption for Ingress object creation.
4. Do not let untrusted workload owners create or alter controller-wide routing objects, risky annotations, templates, ConfigMaps, or controller settings.
5. Never grant the controller `cluster-admin` as a convenience. Derive RBAC from the exact deployment manifest and required controller behavior; remove unused permissions.
6. Do not expose Kubernetes API tokens, TLS private keys, authorization headers, cookies, or unredacted Secret values in logs, support bundles, prompts, or public issue reports.
7. Pin deployable artifacts by immutable digest; verify their origin and signature/attestation where supported. Tags alone are mutable references.
8. Treat a vulnerability scan as one evidence source, not a security certification. A scan configured with `exit-code: 0` is not a blocking vulnerability gate.
9. Fail closed for authorization decisions that govern CIP-protected artifacts and administrative workflows. Kubernetes runtime authorization remains enforced by Kubernetes RBAC/admission and the selected gateway's native policy model, not by client UI flags or an LLM.
10. Preserve original manifests and logs before applying changes; test in a non-production cluster first.

## Interim controls when an existing deployment must remain temporarily

These controls reduce exposure but do not restore upstream security support:

- Assign a named operator and documented end date for the temporary exception.
- Inventory the exact controller image digest, chart version, namespace, ServiceAccount, ClusterRoles/RoleBindings, IngressClasses, ConfigMaps, annotations, and exposed Services.
- Restrict who can create or update Ingress resources and related configuration; review admission policy for high-risk annotations.
- Keep the controller in a dedicated namespace and avoid sharing it across mutually untrusted tenants.
- Minimize Kubernetes RBAC, container capabilities, host mounts, host networking, and egress; verify the actual deployment before changing them.
- Restrict administrative endpoints and metrics to trusted networks.
- Enforce TLS, certificate rotation, request-size/time limits, and upstream network segmentation through reviewed configuration.
- Monitor configuration reload failures, unexpected route changes, 4xx/5xx spikes, resource exhaustion, controller restarts, and anomalous outbound connections.
- Maintain tested rollback and an incident path for credential rotation and traffic cutover.
- Keep the migration moving; do not turn an interim exception into an indefinite support promise.

## CIP mapping

Applicable CIP principles: provenance before confidence; explicit ownership; authorization before retrieval; server-side authority; default deny; least privilege; unknown/conflicted states; auditability; preservation of originals; fail-closed recovery.

The frozen CIP PAE contract is not transplanted into the ingress request path. Its deterministic authorization principle is applied to CIP governance and protected project assets; cluster network policy and Kubernetes authorization are separate enforcement mechanisms.

## Verification required before any workload use

- Inspect actual rendered Helm output and effective RBAC.
- Test controller behavior with malicious and malformed Ingress inputs in an isolated cluster.
- Verify cross-namespace and cross-tenant boundaries.
- Confirm secrets are not exposed through API responses, logs, metrics, traces, debug endpoints, or CI output.
- Test session/credential revocation for operators and CI identities.
- Verify image digest, provenance, vulnerability results, and rollback artifact.
- Confirm the temporary deployment is still supported by a vendor or plan immediate migration.

No cluster-specific controls above have been applied or tested in this repository.
