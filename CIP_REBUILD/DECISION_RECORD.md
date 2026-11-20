# Architecture Decision Record: CIP Gateway Migration

- **ID:** CIP-ADR-K8S-GW-001
- **Version:** 0.2.1
- **Status:** PROPOSED
- **Date:** 2026-11-20
- **Authority:** Frozen CIP-VNEXT-AUTH-001 v0.1.0 remains unchanged and normative.

## Context

This repository is a fork of Ingress NGINX, not the Kubernetes project itself. Its root README documents retirement and advises users who are not already deploying it to select a Gateway API implementation. A rebuild of this repository would therefore preserve and extend a retired ingress controller rather than solve the desired long-term ingress problem.

The CIP deployment requires explicit separation between infrastructure routing and application-level authorization. It also requires security properties to hold across multiple application replicas and asynchronous work.

## Decision proposed

- Keep this fork's existing history intact as a legacy reference.
- Do not add new production features to Ingress NGINX here.
- Build the replacement ingress layer around Kubernetes Gateway API.
- Evaluate implementations against Gateway API conformance, maintained release status, supported Kubernetes versions, security advisories, policy model, observability, upgrade path, and provider compatibility.
- Treat Envoy Gateway as an evaluation candidate only; do not install or pin it until the compatibility review is completed for the actual cluster.
- Keep cluster provisioning and application deployment separate from this controller source repository unless repository ownership and release responsibilities are explicitly approved.

## CIP invariants

1. PAE authorization is server-side and deterministic.
2. Authorization precedes retrieval of protected content and any creation of derived delivery capabilities.
3. Kubernetes RBAC and Gateway API permissions do not grant CIP data access.
4. Sessions, revocation epochs, policy versions, cache invalidation, and audit state cannot be authoritative only in one Pod's memory when multiple replicas are active.
5. Audit delivery must be durable, tamper-evident to the extent supported by the selected storage design, and failure behavior must be explicit.
6. Agent execution, if introduced, requires a separate threat model, identity, resource boundary, egress policy, and approval gate.
7. Device context is not identity proof; client-provided identity/ownership claims are not trusted authorization inputs.

## Alternatives considered

### Continue developing the Ingress NGINX fork
Rejected for new production routing because the upstream project is retired and its own README warns against new deployments.

### Replace it with an unspecified Gateway API implementation
Not sufficient as an implementation decision. Gateway API is an API, not a controller. A concrete implementation and compatibility matrix are required.

### Select Envoy Gateway immediately
Deferred. It is a candidate, but the target cluster/provider and exact supported version set are not established in this repository.

## Consequences

Positive:
- Avoids investing in a retired controller.
- Separates routing from CIP authorization.
- Allows implementation selection based on a documented compatibility/security review.
- Preserves the legacy repository history.

Costs and risks:
- Existing Ingress annotations and controller-specific behavior need explicit translation.
- Gateway API CRD ownership and controller lifecycle must be assigned.
- NetworkPolicy enforcement depends on the CNI.
- Provider, DNS, certificates, identity, observability, and secret delivery remain open inputs.

## Rollback

Keep the legacy ingress deployment configuration and artifacts available during migration, but do not assume they remain safe for continued exposure. Rollback must be time-bounded, security-reviewed, and based on a tested traffic-switch procedure. A rollback to a retired controller is not an acceptable long-term remediation for a security defect.

## Approval required

This ADR is a proposal. It requires explicit platform-owner approval and a selected target environment before implementation.
