#!/usr/bin/env bash
set -euo pipefail

[[ "${CIP_ALLOW_RETIRED_INGRESS_NGINX:-}" == "true" ]] || {
  echo "Refusing: set CIP_ALLOW_RETIRED_INGRESS_NGINX=true only for an approved, time-bounded legacy exception." >&2; exit 2;
}
EXPECTED_CONTEXT="${CIP_EXPECTED_KUBE_CONTEXT:-}"
CURRENT_CONTEXT="$(kubectl config current-context)"
[[ -n "$EXPECTED_CONTEXT" && "$CURRENT_CONTEXT" == "$EXPECTED_CONTEXT" ]] || {
  echo "Refusing: expected kube context must exactly match current context ($CURRENT_CONTEXT)." >&2; exit 3;
}
command -v helm >/dev/null
command -v kubectl >/dev/null
CHART_VERSION="$(helm show chart ./charts/ingress-nginx | awk '/^version:/ {print $2; exit}')"
[[ "$CHART_VERSION" == "4.15.1" ]] || {
  echo "Expected local chart 4.15.1, found '$CHART_VERSION'. Review before continuing." >&2; exit 4;
}
grep -q 'digest: sha256:594ceea76b01c592858f803f9ff4d2cb40542cae2060410b2c95f75907d659e1' legacy/values-cip.yaml || {
  echo "Pinned controller digest mismatch." >&2; exit 5;
}
helm template cip-legacy-ingress ./charts/ingress-nginx \
  --namespace cip-legacy-ingress -f legacy/values-cip.yaml >/tmp/cip-legacy-rendered.yaml
echo "Rendered manifests to /tmp/cip-legacy-rendered.yaml for inspection."
echo "Active kube context: $CURRENT_CONTEXT"
read -r -p "Type INSTALL-RETIRED-INGRESS to proceed: " CONFIRM
[[ "$CONFIRM" == "INSTALL-RETIRED-INGRESS" ]] || { echo "Cancelled."; exit 6; }

helm upgrade --install cip-legacy-ingress ./charts/ingress-nginx \
  --namespace cip-legacy-ingress --create-namespace \
  -f legacy/values-cip.yaml --wait --timeout 10m
kubectl -n cip-legacy-ingress rollout status deployment/cip-legacy-ingress-controller --timeout=180s || true
helm status cip-legacy-ingress -n cip-legacy-ingress
echo "Legacy chart installed. This does not establish security support or production readiness."
