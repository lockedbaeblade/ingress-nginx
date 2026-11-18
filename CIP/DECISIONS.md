# CIP decision log

## ADR-CIP-ING-001 — Treat the inherited Ingress NGINX fork as a legacy reference

- **Date:** 2026-11-18
- **Status:** PROPOSED decision for owner review
- **Context:** The upstream Kubernetes Ingress NGINX project was retired and its repository archived on 2026-03-24. The downstream repository is a fork and its latest inspected main commit is an upstream release commit dated 2026-03-19. No independent downstream security maintenance was demonstrated.
- **Decision:** Preserve this repository's upstream code and history as a provenance/migration reference. Do not make it the new production ingress platform. Evaluate a maintained Gateway API implementation for active routing.
- **Consequences:** No controller binaries/images/charts are published by this overlay. Existing deployments require inventory and a controlled migration; they are not assumed to be broken or safe. The Gateway API implementation is selected only after environment and feature discovery.
- **Alternatives considered:**
  1. Rebrand the fork and continue maintenance immediately — rejected because a real patch, test, release, and incident-response capability has not been evidenced.
  2. Delete the fork — rejected because it would discard a useful source and migration reference.
  3. Keep operating indefinitely without migration — rejected because upstream security updates ended.
- **Acceptance criteria:** a complete Ingress inventory; explicit feature/annotation mapping; selected conformant implementation; security and functional tests; tested cutover and rollback; legacy controller removed or time-bounded exception approved.
- **Rollback:** This decision is documentation-only and reversible. No workload or Git history is changed.
