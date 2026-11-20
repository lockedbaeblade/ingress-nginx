# CIP Gateway Implementation Plan

**Status:** PROPOSED / planning artifact only  
**Version:** 0.2.2  
**Authority:** CIP-VNEXT-AUTH-001 v0.1.0 remains frozen and normative  
**Parent:** CIP-ADR-K8S-GW-001 v0.2.1

## Objective

Replace the retired Ingress NGINX edge for CIP workloads with a selected, maintained Kubernetes Gateway API controller, while preserving CIP's server-side Policy Authorization Engine (PAE) as the only authority for protected application data.

This plan does not select a controller, provider, Kubernetes version, CNI, identity provider, DNS service, certificate issuer, or storage vendor. Those are environment-specific decisions and must be recorded before implementation.

## Workstreams and exit criteria

### W0 — Ownership and environment baseline
- Identify platform owner, application owner, security approver, operations/on-call owner, and rollback authority.
- Record provider, cluster name/region, Kubernetes version/patch, CNI/version, DNS, certificate issuer, registry, identity provider, observability, storage, and secrets manager.
- Record repository commit, deployment artifact digests, current ingress inventory, and approved maintenance window.

**Exit:** All required owners and environment fields are populated and approved. Unknown values remain explicitly UNKNOWN; no assumptions are substituted.

### W1 — Gateway implementation selection
Evaluate at least two currently maintained Gateway API implementations. Score conformance/API versions, Kubernetes/provider compatibility, support and security response, TLS integration, policy model, observability, load-balancer/source-IP behavior, upgrades/rollback, CRD ownership, licensing, image provenance, SBOM and supply-chain controls.

**Exit:** A version-pinned ADR names the selected controller, alternatives, compatibility evidence, residual risks, CRD owner, upgrade owner, and rollback approach. A vendor/product name alone is not approval.

### W2 — Route and behavior inventory
- Export Ingress objects and IngressClass definitions without Secret values.
- Inventory annotations, ConfigMaps, admission webhooks, TLS hosts, rewrites, redirects, auth, CORS, body-size limits, timeouts, source-IP behavior, rate limits, allowlists, snippets, TCP/UDP services and default backends.
- Classify each behavior as equivalent, implementation-specific replacement, unsupported, or unknown.
- Use ingress2gateway only as a conversion aid; review generated output manually.

**Exit:** Every existing route and security-relevant behavior has an owner, target mapping, test, and disposition. Unsupported or ambiguous behavior blocks cutover.

### W3 — Staging platform
- Install the chosen Gateway API CRDs/controller in a non-production cluster.
- Pin controller and workload images by digest.
- Apply namespace isolation, Pod Security Admission, least-privilege ServiceAccounts/RBAC, NetworkPolicy, resource quotas/limits, disruption budgets and observability.
- Validate CRD lifecycle ownership and controller upgrade/rollback.
- Confirm the actual CNI enforces NetworkPolicy.

**Exit:** Cluster policy and network tests pass on the actual target CNI; controller health and Gateway status are observable; no production traffic has moved.

### W4 — CIP application security integration
- Keep Gateway routing separate from application authorization.
- Authenticate requests and resolve principal, workspace, membership, session and revocation state server-side.
- Enforce deterministic PAE before protected database/object reads, search-result disclosure, export, presigned URL creation, and AI/agent context construction.
- Make policy versions, revocation state, cache invalidation and audit durable across replicas.
- Ensure client-supplied role, owner, tenant, device, or admin fields never grant access.
- Define explicit behavior when policy, identity, shared state or audit services are unavailable.

**Exit:** Direct API and cross-tenant tests prove protected data cannot be retrieved before PAE allows it. Two or more replicas share authoritative session/policy/audit state. Fail-closed behavior is tested.

### W5 — Functional, adversarial and resilience tests
Run the complete acceptance gates in ACCEPTANCE_GATES.md and attach machine-readable results. Include route parity and negative routing cases; unauthenticated, unauthorized, cross-tenant and revoked-session cases; direct Pod/API bypass attempts; replica A session / replica B validation and revocation; stale policy cache and shared-store outage; audit backpressure and failure; CNI NetworkPolicy enforcement and egress denial; load, restart, rolling update and disruption; backup restore and traffic rollback.

**Exit:** Every BLOCKER passes. Any exception has an owner, expiry, compensating control and explicit security approval. No unresolved critical finding is waived by default.

### W6 — Controlled cutover
- Approve maintenance window and communications.
- Verify backups and rollback runbook.
- Run parallel/canary traffic where supported.
- Compare route results, TLS, headers, source-IP, latency, error rate, audit completeness and backend health.
- Shift traffic in bounded increments with explicit stop thresholds.
- Keep the old path only as a time-bounded, security-reviewed fallback.

**Exit:** Platform owner and security approver sign recorded evidence; rollback is rehearsed; old controller resources are removed only after traffic and dependencies are verified.

### W7 — Operations and lifecycle
- Assign patch, CVE, CRD, certificate, DNS, backup, restore, alert and incident ownership.
- Monitor Gateway/HTTPRoute conditions, TLS expiry, 4xx/5xx, latency, upstream failures, denied policy decisions, audit delivery and resource saturation.
- Document support windows, upgrade cadence, emergency rollback and end-of-life replacement triggers.

**Exit:** Runbooks, alerts, support ownership and recovery tests are accepted before production release.

## Stop conditions
- Controller/Kubernetes version compatibility is unsupported or unknown.
- CRD ownership is ambiguous.
- Route behavior changes without an approved disposition.
- PAE is bypassed or cannot establish authorization state.
- Policy/session/audit state diverges across replicas.
- NetworkPolicy is assumed but not enforced by the CNI.
- Image provenance or critical vulnerability status is unresolved.
- Backup restore or traffic rollback has not been demonstrated.

## Required evidence bundle

For each gate retain: source commit, environment identifiers (redacted where needed), tool/controller versions, artifact digests, commands, timestamps/timezone, raw test output, reviewer, result, exceptions, and approval. Never store credentials, kubeconfig, Secret values, presigned URLs, or private keys in this repository.

## Release status vocabulary
- PROPOSED: plan exists; no implementation implied.
- SCAFFOLDED: initial manifests/code exist; not necessarily integrated.
- INTEGRATED: connected to target environment.
- TESTED: named tests ran; attach results.
- VERIFIED: acceptance criteria reproducibly passed.
- RELEASED: authorized production cutover completed.

A green manifest linter is not a security verification or deployment approval.