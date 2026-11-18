# Migration plan: Ingress NGINX → Kubernetes Gateway API

**Status:** RECOMMENDED; environment discovery required before implementation.  
**Target:** replace the retired controller for active edge routing.

## Why this is the chosen direction

Kubernetes SIG Network and the Security Response Committee retired Ingress NGINX on 2026-03-24. Kubernetes states that existing deployments continue to function and artifacts remain available, but there will be no further upstream releases, bug fixes, or security updates. Remaining operational does not mean remaining supported.

Gateway API is the successor API recommended by Kubernetes. It is a family of Kubernetes resources, not a complete proxy by itself; select a controller implementation that is currently maintained, conforms to the required Gateway API features, and fits the target platform.

## Phase 0 — establish the real environment

Before writing or applying manifests, record:

- Cluster provider, region, Kubernetes version, current context, and authorization to inspect.
- Existing Ingress controller namespaces, Deployments, image digests, Helm releases, Services, IngressClasses, and RBAC.
- All Ingress resources across namespaces, TLS Secret references (never export Secret data), ConfigMaps, and controller-specific annotations/CRDs.
- DNS provider, load-balancer type, firewall/security groups, certificate automation, WAF, observability, and availability/rollback requirements.
- Whether the cluster is single-tenant or hosts mutually untrusted teams.

Do not run cluster-wide discovery commands until the operator confirms the active kube context and is authorized. The official Kubernetes retirement notice suggests a selector-based pod check; that command needs cluster-wide permissions.

## Phase 1 — preserve and inventory

1. Export declarative resources to a restricted working directory.
2. Preserve an immutable original copy and create a separate sanitized migration copy.
3. Record timestamps, source cluster/context, filenames, and SHA-256 hashes.
4. Remove Secret values, kubeconfig credentials, tokens, private keys, and customer data from any shareable copy.
5. Create an inventory mapping each Ingress to its class, hostname, path rules, backend, TLS reference, annotations, and owner.

## Phase 2 — convert as an aid, not an authority

The Kubernetes SIG-Network project `ingress2gateway` provides an Ingress-to-Gateway API conversion assistant. It supports an `ingress-nginx` provider and a standard Gateway API emitter. It explicitly warns that some provider-specific annotations/CRDs may be unsupported and that it does not simply copy annotations.

Prefer file input so the first conversion does not require cluster credentials:

```bash
ingress2gateway print \
  --providers=ingress-nginx \
  --input-file ./migration-input/ingresses-sanitized.yaml \
  --output yaml \
  > ./migration-output/gateway-candidates.yaml
```

Use the tool's current release documentation to confirm flags before execution. Keep generated output in a working directory, not directly in a production manifest path.

For a cluster-based read, an operator may use the tool's supported all-namespaces mode only after verifying kube context, permissions, and data-handling policy. Do not send kubeconfig files or Secret values to an AI agent or public repository.

## Phase 3 — feature-by-feature review

For every source Ingress, compare observed behavior to the generated Gateway API resources. Specifically review:

- host and path matching precedence;
- TLS listeners and certificate references;
- redirects, rewrites, regex behavior, and path normalization;
- authentication/authorization and identity headers;
- CORS and request/response headers;
- source-IP allow/deny behavior;
- request body size and timeouts;
- backend TLS verification;
- rate limits, buffering, sticky sessions, TCP/UDP routes, and health checks;
- snippets, custom templates, ConfigMaps, and unsupported vendor extensions.

A converted manifest is a candidate, not proof of behavioral equivalence. Untranslated or unsupported items remain explicit blockers until replaced and tested.

## Phase 4 — choose an implementation

Evaluate implementations against the official Gateway API conformance list and your platform needs. Compare supported API versions, conformance, supported filters/policies, RBAC boundaries, security-response commitments, upgrade cadence, Helm/GitOps integration, observability, load-balancer integration, and operational complexity.

Possible implementations listed by the Gateway API project include Envoy Gateway, Cilium, Istio, NGINX Gateway Fabric, Kong, and Traefik. This list is not an endorsement or a ranking. Re-check current conformance and lifecycle data at selection time.

## Phase 5 — parallel validation and cutover

1. Install the chosen controller and Gateway API CRDs in a non-production environment.
2. Apply generated candidates only after manual review.
3. Test each route with positive, negative, auth, TLS, redirect, timeout, large-body, and failure scenarios.
4. Run the new gateway in parallel with the legacy path where platform topology permits.
5. Compare status codes, headers, latency, TLS chain, logs, metrics, and backend reachability.
6. Perform a controlled canary/DNS traffic shift with an operator-approved rollback point.
7. Keep the legacy path only for the shortest approved transition window, then remove its RBAC, workloads, Services, firewall rules, and secrets after confirming no traffic depends on them.

## Acceptance criteria

- Every current Ingress has an owner and a documented disposition.
- Every annotation/CRD is mapped, replaced, or recorded as an explicit blocker.
- TLS material is referenced securely and never embedded in migration artifacts.
- Gateway routes are accepted by the controller and pass conformance/functional tests.
- Auth and namespace boundaries are tested with unauthorized requests.
- DNS/load-balancer cutover and rollback are rehearsed.
- Monitoring and incident ownership are assigned.
- The legacy controller is removed or a time-bounded exception is approved.

No cluster inventory, conversion, installation, traffic test, or cutover was performed in this documentation work.
