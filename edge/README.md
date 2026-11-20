# CIP Edge Gateway v0.2.0

**Status:** SCAFFOLDED — deployable manifests and guarded install/verification scripts are committed; NOT deployed or cluster-tested.  
**Gateway implementation:** Envoy Gateway v1.10.0  
**Compatibility target:** Kubernetes 1.34–1.37, Gateway API v1.6.1 (verify actual cluster first).

## Architecture

- Envoy Gateway is the active edge path for new services.
- Gateway API resources define listeners, hostnames, TLS and routes.
- HTTP requests are redirected to HTTPS.
- The demo route is deliberately addressed to `app.example.test`; replace it with a hostname you control.
- A TLS Secret named `cip-edge-tls` must exist in namespace `cip-edge-system` before the Gateway is applied.
- CIP PAE integration is specified separately. Until a real PAE-backed external authorization service is integrated and tested, do not claim that Gateway requests are authorized by CIP.

## Install

From the repository root, after verifying the target kube context and cluster version:

```bash
export CIP_EXPECTED_KUBE_CONTEXT="$(kubectl config current-context)"
./edge/install.sh
```

The script installs the pinned Gateway API CRDs and Envoy Gateway Helm chart version 1.10.0, creates the namespaces, checks for the TLS Secret, and applies the Gateway and sample app resources. It does not create DNS records or cloud load balancers.

Create the TLS Secret before installation (after the namespaces exist):

```bash
kubectl create namespace cip-edge-system --dry-run=client -o yaml | kubectl apply -f -
kubectl -n cip-edge-system create secret tls cip-edge-tls \
  --cert=/secure/path/fullchain.pem --key=/secure/path/privkey.pem
```

Never commit certificate or private-key files. In production, prefer cert-manager or your platform's certificate controller and document its renewal/rotation process.

## Verify

```bash
./edge/verify.sh
```

Then point DNS for the chosen hostname at the Gateway's external address and test both HTTP redirect and HTTPS route. Do not use the placeholder hostname in production.

## Change/rollback

- Pin upgrades to a reviewed Envoy Gateway release and matching compatibility matrix.
- Back up Gateway API resources and TLS/certificate-controller configuration before upgrades.
- Roll back the Helm release to the previous chart version; do not downgrade CRDs without a compatibility review.
- To remove the demo only: `kubectl delete -f edge/manifests/demo-app.yaml`.
- Full controller uninstall is an operator action and may disrupt every route attached to this GatewayClass.

## Security boundary

This is a baseline edge-routing scaffold, not a complete internet-facing security certification. Before production, add and test WAF/rate limiting, upstream network policy, workload identity, observability, certificate automation, external authorization where required, DDoS protections, and a rehearsed rollback. Do not expose the Envoy Gateway admin/control-plane endpoints publicly.
