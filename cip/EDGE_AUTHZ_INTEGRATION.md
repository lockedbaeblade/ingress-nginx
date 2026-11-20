# CIP PAE integration contract for the edge

**Status:** DESIGNED — integration NOT IMPLEMENTED or tested.

## Authority boundary

The frozen CIP authority is `CIP-VNEXT-AUTH-001 v0.1.0`. The PAE contract accepts a principal, action, resource and context, and returns one of `ALLOW`, `DENY`, `CHALLENGE`, or `REVIEW`, with reason codes, policy identifiers/version, obligations and an audit event identifier.

The uploaded implementation map identifies remaining integration gaps: persistent policy repository, authentication/session provider, audit/security-event store, production observability, and target-app end-to-end tests. The no-device work pack also requires authorization before protected retrieval, default deny, workspace isolation, revocation, token/secret redaction, provenance and release gates.

## Edge mapping

- An authenticated request must be bound to a server-validated principal and session. Never trust identity, role, workspace, owner, or permission headers supplied by an internet client.
- The adapter maps the request to the PAE action/resource/context contract. The PAE remains deterministic and server-side; an LLM is not an authorization engine.
- Only PAE `ALLOW` may continue to the upstream. `DENY`, `CHALLENGE`, `REVIEW`, timeout, malformed response, unavailable policy store, invalid session, or audit-write failure must fail closed.
- Do not forward bearer tokens, cookies, authorization headers, private claims, or internal policy detail to upstream services unless an explicitly approved policy requires it.
- Challenge/review flows must not disclose protected content before completion.
- Log request ID, decision ID, policy ID/version, reason codes and audit event ID; redact credentials, cookies, tokens and sensitive payloads.

## Envoy Gateway integration gate

Implement the adapter as a separate, independently deployable service behind a private Kubernetes Service. Attach it to Envoy Gateway using the exact `SecurityPolicy` external-authorization schema supported by the pinned Envoy Gateway v1.10.0 release. Do not copy an unverified example or assume generic Envoy ext_authz configuration is interchangeable with the Gateway API policy CRD.

Before attaching the policy:
1. Integrate the real Context Vault authentication/session store.
2. Replace in-memory policy storage with the persistent policy repository.
3. Connect a durable audit/security-event writer.
4. Implement strict request/response validation and bounded timeouts.
5. Prove all non-ALLOW decisions, unavailable dependencies and malformed responses fail closed.
6. Test direct upstream access bypass, header spoofing, session revocation, replay, cache invalidation and cross-workspace access.
7. Pass applicable CIP BLOCKER tests and edge-specific negative tests.

Until this gate passes, the demo route is a routing demonstration only, not a CIP-protected application.
