# CIP release and change-control gate

**Policy status:** PROPOSED for this fork.  
**Default decision:** no supported controller release from this repository.

## Current release posture

The upstream project was retired on 2026-03-24. The inspected downstream fork has no demonstrated independent maintenance team, security response contact, release process, downstream image provenance, or target-cluster verification. A writable GitHub repository is not a release qualification.

## Allowed changes during legacy-reference status

- Documentation corrections that preserve original upstream meaning and attribution.
- Provenance indexes, migration inventories, threat models, and read-only analysis.
- Reversible, reviewed migration tooling kept separate from the retired controller binary.

## Blocked without a separately approved maintenance program

- Publishing a new controller image or Helm chart as maintained or security-supported.
- Changing default controller behavior and representing it as upstream-supported.
- Deleting/overwriting upstream history, license notices, security warnings, or contributor records.
- Deploying this controller into a new production cluster.
- Claiming a scan or green CI run proves the controller is secure.

## Required gates for any future downstream controller release

All must be satisfied before a human release approver authorizes publication:

1. A named, accountable maintainer group and on-call vulnerability response process.
2. Written support scope, supported Kubernetes versions, patch windows, and end-of-life policy.
3. A reviewed fork delta and a documented upstream sync/security backport strategy.
4. Locked default branch, required reviews, CODEOWNERS, and least-privilege GitHub Actions permissions.
5. Dependency and source scanning with severity-based blocking thresholds and an exception/expiry process.
6. Reproducible build from an immutable commit, pinned actions/dependencies, provenance attestation, SBOM, signed image digest, and registry access controls.
7. Helm rendering, Go tests, static analysis, image tests, Kubernetes integration/e2e tests, and regression checks.
8. RBAC, namespace isolation, secret-handling, unsafe annotation, and direct API abuse tests.
9. Backup, rollback, incident response, and revocation plan.
10. All applicable CIP security DoD blockers pass; all controller-specific cases are also addressed.
11. Independent review/red-team evidence and explicit human approval.
12. Release manifest records source commit, tree, toolchain, image digest, SBOM, attestations, test evidence, approver, and timestamp.

## CIP test interpretation

CIP-VNEXT-AUTH-001's PAE and workspace tests are authoritative for Context Vault. For this repository, use the applicable principles (default deny, least privilege, provenance, audit, fail-closed behavior, and bounded automation) and add Kubernetes-native tests. Do not claim that all 60 Context Vault DoD cases are directly applicable to an ingress controller.

## Change protocol

- Preserve upstream-origin files where possible.
- Make changes on short-lived, reviewable branches.
- Never force-update `main`.
- Record the exact base commit and file hashes before changes.
- Test only in an isolated environment unless explicit production authorization and rollback are present.
- Revoke compromised CI credentials and rotate secrets rather than trying to preserve an unsafe deployment.
- Keep documentation status as PROPOSED/DESIGNED until checks actually run.
