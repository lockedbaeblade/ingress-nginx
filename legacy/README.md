# Retired Ingress NGINX — controlled legacy operations pack

**Status:** SCAFFOLDED; no cluster deployment or security certification.  
**Chart:** local `charts/ingress-nginx`, version 4.15.1  
**Controller:** v1.15.1  
**Image:** digest pinned in inherited chart values (`sha256:594ceea76b01c592858f803f9ff4d2cb40542cae2060410b2c95f75907d659e1`).

## What “operable” means here

This pack preserves a reproducible, explicit way to render and install the retired chart in an existing authorized cluster. It does not restore upstream support, create security fixes, or make the controller safe for new production deployments. The Kubernetes project states there will be no further bug fixes or security updates after retirement.

The install script is deliberately gated by:
- `CIP_ALLOW_RETIRED_INGRESS_NGINX=true`
- `CIP_EXPECTED_KUBE_CONTEXT` matching the active context
- an explicit local chart in this repository
- a chart version check for 4.15.1

The controller is isolated to its own namespace and dedicated IngressClass. It does not process classless Ingress resources, does not allow snippet annotations, uses the chart's pinned image digest, enables validating admission webhooks with failurePolicy Fail, and requests two replicas. These are risk-reduction controls, not a security support promise. The Service uses LoadBalancer with an empty source-range allowlist (publicly reachable where the platform provisions a public load balancer); set `controller.service.loadBalancerSourceRanges` to the actual approved CIDRs before exposing it where source restriction is required.

## Install

```bash
export CIP_ALLOW_RETIRED_INGRESS_NGINX=true
export CIP_EXPECTED_KUBE_CONTEXT="$(kubectl config current-context)"
./legacy/install.sh
```

The script installs from the local chart path `charts/ingress-nginx`; do not substitute a floating remote chart or mutable image tag.

## Add a legacy Ingress

The example uses a placeholder hostname and a backend service in the same namespace. Replace the hostname, ensure the TLS Secret exists in that namespace, and review all annotations. Apply only after confirming that the legacy controller is the intended owner.

```bash
kubectl apply -f legacy/examples/ingress-example.yaml
```

## Verify / rollback

```bash
./legacy/verify.sh
helm history cip-legacy-ingress -n cip-legacy-ingress
helm rollback cip-legacy-ingress PREVIOUS_REVISION -n cip-legacy-ingress
```

Do not remove the release until traffic has been migrated and the Gateway API rollback plan is accepted. Do not operate this controller as a multi-tenant security boundary. Keep a named owner and a dated retirement exception for any existing use.
