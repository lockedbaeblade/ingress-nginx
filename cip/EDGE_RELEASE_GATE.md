# CIP edge release gate

## Edge Gateway v0.2.0 — current status

- [x] Gateway API and Envoy Gateway version selected from current release compatibility data.
- [x] Pinned Envoy Gateway chart/CRD version 1.10.0.
- [x] Kubernetes minor-version guard (1.34–1.37).
- [x] Context guard before install.
- [x] HTTPS listener and HTTP-to-HTTPS redirect resources.
- [x] Demo workload with no ServiceAccount token and restrictive container security context.
- [x] Legacy controller install is opt-in, context-guarded, version-checked and image-digest-pinned.
- [x] Shell syntax check (`bash -n`) passed for both install scripts.\n- [x] YAML syntax parsing passed for all five committed YAML documents.\n- [ ] Kubernetes API schema validation run against the pinned CRDs.
- [ ] Helm render executed against this branch in a real checkout.
- [ ] Install and runtime verification on a supported test cluster.
- [ ] TLS certificate issuance/rotation tested.
- [ ] Public DNS/load-balancer and end-to-end tests.
- [ ] CIP PAE external authorization adapter integrated and tested.
- [ ] Negative authorization, bypass, replay, revocation and cross-namespace tests.
- [ ] SBOM, provenance attestation and image signature verification for all deployable images.

## Legacy controller

The legacy install path is a reproducible operational aid, not an upstream security maintenance program. It must remain time-bounded and must not be the default path for new services.

## Release decision

Current status is SCAFFOLDED. No production release or deployment is authorized by these files. All unchecked items are NOT TESTED or NOT VERIFIED.
