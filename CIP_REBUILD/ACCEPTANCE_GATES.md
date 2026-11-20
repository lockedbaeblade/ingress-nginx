# CIP Kubernetes Gateway Migration — Acceptance Gates

**Status:** Designed test plan. No tests in this document are claimed to have run.

A release must not proceed merely because manifests parse or a controller starts. Each gate requires recorded evidence from the target environment.

## Gate 0 — Authority and scope

- [ ] Confirm repository and platform ownership.
- [ ] Confirm frozen CIP-VNEXT-AUTH-001 v0.1.0 and record any proposed amendments separately.
- [ ] Identify cluster provider, Kubernetes version/patch, CNI, Gateway controller, CRD owner, DNS, certificate issuer, identity provider, registry, storage, and rollback owner.
- [ ] Record the exact source commit and artifact digests.

**Fail condition:** Any required owner, authority, or environment is unknown.

## Gate 1 — Compatibility and supply chain

- [ ] Verify Gateway API version and CRDs against the selected controller release.
- [ ] Verify controller support for the exact Kubernetes minor/patch and provider.
- [ ] Review current security advisories, release support, upgrade policy, and end-of-life dates.
- [ ] Pin images by digest; verify signature and provenance under an approved trust policy.
- [ ] Generate and retain an SBOM; scan images and dependencies.
- [ ] Confirm CRDs are installed and upgraded by exactly one designated owner.

**Fail condition:** Unsupported version combination, unverifiable image provenance, unresolved critical/high finding without an approved exception, or ambiguous CRD ownership.

## Gate 2 — Routing parity

- [ ] Inventory every Ingress, annotation, path rule, TLS host, authentication layer, rewrite, timeout, body-size limit, rate limit, source-IP behavior, and upstream dependency.
- [ ] Map each behavior to Gateway API and the selected implementation.
- [ ] Mark unsupported or semantically different behaviors as blockers.
- [ ] Test HTTP/HTTPS, redirects, host/path matching, large bodies, timeouts, upstream failure, client disconnect, and malformed requests.
- [ ] Validate certificate renewal and expiry alerting.
- [ ] Test gradual traffic shift and rollback.

**Fail condition:** Any route or security behavior is silently dropped or changes without approval.

## Gate 3 — Authorization and tenant isolation

- [ ] Verify that a valid route does not imply authorization to CIP resources.
- [ ] Test unauthenticated, unauthorized, cross-tenant, revoked-session, expired-session, and stale-policy requests.
- [ ] Prove PAE runs before database/object retrieval, export, presigned URL creation, and AI/agent context construction.
- [ ] Attempt direct API calls that bypass the UI and Gateway.
- [ ] Verify server-side ownership and tenant binding; ignore client-supplied role/owner/tenant/device claims.
- [ ] Verify Kubernetes ServiceAccounts and RBAC cannot read application data stores or Kubernetes Secrets beyond their explicit need.

**Fail condition:** Any protected resource is returned or made retrievable before PAE authorization succeeds.

## Gate 4 — Multi-replica consistency

- [ ] Run at least two application replicas.
- [ ] Create a session on replica A and validate it through replica B.
- [ ] Revoke a session and verify all replicas reject it within the approved revocation objective.
- [ ] Change policy version and verify cache invalidation across replicas.
- [ ] Simulate shared-state and audit-sink outages.
- [ ] Verify fail-closed behavior where authorization state cannot be established.
- [ ] Verify no in-memory replica-local state is treated as authoritative.

**Fail condition:** Replica divergence permits stale authorization or loss of required audit events.

## Gate 5 — Network and workload security

- [ ] Enforce restricted Pod Security Admission for application namespaces.
- [ ] Require non-root, read-only root filesystem where supported, RuntimeDefault seccomp, dropped capabilities, no privilege escalation, and no host namespaces/hostPath.
- [ ] Disable automatic service-account token mounting unless a documented API use requires it.
- [ ] Verify NetworkPolicy with actual CNI tests, including denied ingress and egress paths.
- [ ] Verify only required DNS, Gateway, database, object-store, identity, and telemetry destinations are reachable.
- [ ] Test direct Pod access and lateral movement attempts.
- [ ] Verify resource requests/limits, quotas, disruption budgets, and autoscaling behavior under load.

**Fail condition:** A declared policy is not enforced by the runtime/CNI or a workload exceeds its approved privilege boundary.

## Gate 6 — Audit, recovery, and operations

- [ ] Verify audit records identify actor, action, target, decision, policy version, correlation ID, timestamp, and outcome where required by the frozen contract.
- [ ] Test audit-sink unavailability and backpressure; record whether operations fail closed or enter an explicitly approved durable queue.
- [ ] Test backup restore for application database, object metadata/content, configuration, and required audit records.
- [ ] Test key rotation, certificate renewal, secret rotation, and credential revocation.
- [ ] Test controller upgrade and rollback in non-production.
- [ ] Establish alerts, SLOs, on-call ownership, and incident runbooks.

**Fail condition:** Recovery is untested, security-relevant audit can be silently lost, or no accountable operator owns the service.

## Gate 7 — Release authorization

- [ ] All prior gates pass with linked evidence.
- [ ] Security and platform owners approve the exact commit, image digests, manifests, and change window.
- [ ] Rollback steps and abort thresholds are rehearsed.
- [ ] Production change authorization is recorded.

**Release status:** Not authorized until every required gate passes. A successful static YAML check is not production verification.
