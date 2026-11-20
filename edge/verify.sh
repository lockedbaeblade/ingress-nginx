#!/usr/bin/env bash
set -euo pipefail
kubectl get gatewayclass eg
kubectl -n cip-edge-system get gateway cip-public -o wide
kubectl -n cip-edge-system describe gateway cip-public
kubectl -n cip-edge-demo get deployment,service,httproute -o wide
kubectl -n cip-edge-demo rollout status deployment/echo --timeout=120s
kubectl -n cip-edge-system get secret cip-edge-tls >/dev/null
echo "Kubernetes object checks completed. This does not prove external DNS, load-balancer reachability, TLS chain validity, authorization, or end-to-end HTTP behavior."
