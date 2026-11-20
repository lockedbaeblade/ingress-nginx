#!/usr/bin/env bash
set -euo pipefail
kubectl get ingressclass cip-legacy-nginx
kubectl -n cip-legacy-ingress get deployment,pods,service
kubectl -n cip-legacy-ingress rollout status deployment/cip-legacy-ingress-controller --timeout=180s
helm status cip-legacy-ingress -n cip-legacy-ingress
echo "Object checks completed. Separately test DNS, load balancer, TLS, webhook admission, route behavior and rollback."
