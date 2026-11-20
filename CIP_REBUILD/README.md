# CIP Kubernetes Gateway Rebuild

**Status: PROPOSED / DOCUMENTED. Not implemented, deployed, or production-verified.**

This directory records a CIP-led migration proposal for the ingress layer represented by this repository. It does not rebuild Kubernetes upstream, and it does not claim that this repository is a Kubernetes distribution.

## Repository scope

This repository is an Ingress NGINX controller fork. The root README itself states that Ingress NGINX is retired, is not being developed, and should not be selected for new deployments. It also warns against multi-tenant production use under its documented trust assumptions.

Accordingly, this proposal does not add new features to the retired controller or represent a fork as a maintained replacement. Preserve the existing history as a read-only reference while evaluating a supported Gateway API implementation.

## Proposed target

Use the Kubernetes Gateway API as the routing API and select a conformant, actively maintained controller only after a compatibility, security, licensing, and operational review. Envoy Gateway is one candidate for evaluation, not an approved dependency or a pinned production choice.

The deployment design must be provider-neutral until the target Kubernetes provider, supported Kubernetes minor/patch, CNI, DNS, certificate issuer, identity provider, and storage services are confirmed.

## CIP security boundary

Kubernetes controls are infrastructure safeguards; they do not replace CIP's application authorization contract.

- Kubernetes RBAC governs Kubernetes API operations.
- Gateway API governs traffic routing.
- NetworkPolicy constrains Pod network paths, subject to CNI enforcement.
- CIP Policy Authorization Engine (PAE) remains the server-side authority for protected CIP resources.
- PAE authorization must precede protected content retrieval, export, presigned object delivery, and inclusion in AI/agent context.
- Evidence provenance, policy decisions, session/revocation state, and audit records must remain durable and attributable across replicas.
- No client-supplied role, owner, tenant, device, or UI state is an authorization authority.

The frozen CIP specification remains normative. This proposal does not amend it.

## Migration principles

1. Inventory existing Ingress objects, annotations, controller-specific behavior, TLS, authentication, rewrites, rate limits, source IP handling, and upstream dependencies.
2. Translate behavior to Gateway API only where semantics are equivalent and supported by the selected implementation.
3. Mark unsupported or ambiguous behavior as a migration blocker; do not silently approximate it.
4. Run old and new routing paths in a non-production environment with representative traffic and negative security tests.
5. Shift traffic incrementally with an observable rollback path.
6. Retire the old controller only after route parity, security, availability, and recovery acceptance criteria pass.

## Non-goals

- Rewriting Kubernetes upstream.
- Maintaining or extending the retired Ingress NGINX controller as a new production product.
- Deploying a cluster or changing cloud resources from this repository.
- Selecting a cloud provider or assuming existing credentials, DNS, certificates, database endpoints, or object-store configuration.
- Treating Kubernetes network or identity controls as a replacement for PAE.

## Required approvals and inputs

Before implementation, record the selected provider and cluster version, cluster ownership, network plugin/CNI, Gateway controller and version, CRD ownership model, DNS and certificate management, identity integration, observability stack, image registry, and change/rollback authority.

See [DECISION_RECORD.md](DECISION_RECORD.md) and [ACCEPTANCE_GATES.md](ACCEPTANCE_GATES.md).
