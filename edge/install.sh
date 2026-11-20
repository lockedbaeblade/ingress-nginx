#!/usr/bin/env bash
set -euo pipefail

EXPECTED_CONTEXT="${CIP_EXPECTED_KUBE_CONTEXT:-}"
CURRENT_CONTEXT="$(kubectl config current-context)"
if [[ -z "$EXPECTED_CONTEXT" || "$CURRENT_CONTEXT" != "$EXPECTED_CONTEXT" ]]; then
  echo "Refusing install: set CIP_EXPECTED_KUBE_CONTEXT to the exact intended kube context." >&2
  echo "Current context: $CURRENT_CONTEXT" >&2
  exit 2
fi

SERVER_MINOR="$(kubectl version -o json | python3 -c 'import json,sys; print(json.load(sys.stdin)["serverVersion"]["minor"].rstrip("+"))')"
if ! [[ "$SERVER_MINOR" =~ ^[0-9]+$ ]] || (( SERVER_MINOR < 34 || SERVER_MINOR > 37 )); then
  echo "Envoy Gateway 1.10.0 is documented for Kubernetes 1.34–1.37; detected minor: $SERVER_MINOR. Stop and select a supported release." >&2
  exit 3
fi

command -v helm >/dev/null
command -v kubectl >/dev/null
command -v python3 >/dev/null
kubectl auth can-i create customresourcedefinitions.apiextensions.k8s.io | grep -qx yes || {
  echo "Current identity cannot create CRDs." >&2; exit 4;
}

# The pinned Envoy Gateway chart installs compatible Gateway API and Envoy Gateway CRDs.
helm upgrade --install eg oci://docker.io/envoyproxy/gateway-helm \
  --version v1.10.0 --namespace envoy-gateway-system --create-namespace \
  --wait --timeout 10m

kubectl wait --timeout=5m -n envoy-gateway-system deployment/envoy-gateway --for=condition=Available
kubectl apply -f edge/manifests/namespaces.yaml
if ! kubectl -n cip-edge-system get secret cip-edge-tls >/dev/null 2>&1; then
  echo "Missing cip-edge-tls in cip-edge-system. Create it securely, then rerun this script." >&2
  exit 5
fi

kubectl apply -f edge/manifests/gateway.yaml
kubectl apply -f edge/manifests/demo-app.yaml
kubectl -n cip-edge-system wait --for=condition=Programmed gateway/cip-public --timeout=180s || true
kubectl -n cip-edge-system get gateway cip-public -o wide
echo "Install steps completed. Verify Gateway status, external address, DNS, TLS and application behavior before declaring service live."
