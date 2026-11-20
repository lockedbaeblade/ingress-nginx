# CIP repository governance overlay

**Package:** CIP ingress-nginx governance and migration overlay  
**Version:** 0.1.0  
**Assessment date:** 2026-11-18  
**Status:** PROPOSED / DOCUMENTATION-ONLY  
**Target:** `lockedbaeblade/ingress-nginx`

## Purpose

This folder applies Creator Intelligence Program (CIP) evidence, provenance, security, and release-governance principles to this downstream fork. It does not turn the retired Ingress NGINX controller into a maintained product.

## Authority and scope

The frozen technical authority remains **CIP-VNEXT-AUTH-001 v0.1.0**. Its explicit primary implementation target is Context Vault. Its constitutional principles—human agency, provenance, explicit ownership, authorization before retrieval, server-side authority, default deny, least privilege, conflict preservation, historical reconstruction, protected derived data, bounded automation, auditability, token minimization, fail-closed behavior, and preservation of originals—are used here as governance principles where applicable.

This overlay does **not** silently modify the frozen CIP specification or claim that its Context Vault schema, PAE, or application code has been transplanted into this Go/Kubernetes repository. Kubernetes RBAC, admission policy, controller deployment permissions, CI identity, artifact provenance, and cluster operations remain governed by their native mechanisms.

## Repository decision

**Decision ADR-CIP-ING-001:** retain this fork as a clearly labelled legacy reference and migration source; do not treat it as the production ingress platform for new deployments. Prefer a maintained Gateway API implementation for the active edge-routing architecture.

## Documents

- [Repository profile and evidence](REPOSITORY_PROFILE.md)
- [Threat model and interim controls](THREAT_MODEL.md)
- [Gateway API migration plan](GATEWAY_API_MIGRATION.md)
- [Contributor and source provenance](CONTRIBUTOR_PROVENANCE.md)
- [Release and change-control gate](RELEASE_GATE.md)
- [Decision log](DECISIONS.md)
- [Evidence index](EVIDENCE_INDEX.csv)

## Status vocabulary

- **SOURCE FACT:** directly observed in a supplied source or repository metadata.
- **EXTERNAL RESEARCH:** supported by a cited external source and assessment date.
- **INFERENCE:** a reasoned interpretation, not a direct source statement.
- **RECOMMENDATION:** a proposed control or next step.
- **UNKNOWN:** evidence is not available or not yet verified.

## Non-goals

This overlay does not make legal ownership determinations, attribute all upstream intellectual property to the fork owner, assert that a person committed code without commit evidence, guarantee security, or authorize a cluster deployment.


## Edge Gateway implementation package

- [Edge Gateway v0.2.0](../edge/README.md)
- [Controlled legacy operations pack](../legacy/README.md)
- [CIP PAE edge authorization integration contract](../cip/EDGE_AUTHZ_INTEGRATION.md)
- [Edge release gate](../cip/EDGE_RELEASE_GATE.md)
