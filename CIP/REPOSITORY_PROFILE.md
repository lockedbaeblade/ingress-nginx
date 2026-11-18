# Repository profile and current-state assessment

**Snapshot date:** 2026-11-18  
**Repository:** https://github.com/lockedbaeblade/ingress-nginx  
**Default branch:** `main`

## Verified repository facts

| Item | Observed value | Evidence/status |
|---|---|---|
| Repository visibility | Public | SOURCE FACT — GitHub repository metadata |
| Repository type | Fork | SOURCE FACT — `fork: true` |
| Upstream parent | `kubernetes/ingress-nginx` | SOURCE FACT — GitHub parent metadata |
| Parent archive status | Archived | SOURCE FACT — GitHub parent metadata; upstream archive date 2026-03-24 |
| Downstream archive status | Not archived | SOURCE FACT — GitHub repository metadata; this is not proof of active maintenance |
| Default branch | `main` | SOURCE FACT |
| Branch head | `dbb11b92ddb77bee9c35e462479129354c84f939` | SOURCE FACT — GitHub commits API |
| Head commit date | 2026-03-19 | SOURCE FACT — commit metadata |
| Head commit message | Release controller v1.15.1/v1.14.5/v1.13.9 and chart v4.15.1/v4.14.5/v4.13.9 | SOURCE FACT — commit metadata |
| Head commit verification | GitHub reports signature verified | SOURCE FACT limited to that commit only |
| Branch protection | Branch API reports `protected: false` | SOURCE FACT — main branch listing |
| Issues | Disabled in repository metadata | SOURCE FACT |
| Root source | Go controller, chart, deploy, docs, tests, build and release materials | SOURCE FACT — root tree |
| Repository license | Apache-2.0 | SOURCE FACT — GitHub metadata and root LICENSE |
| Root README warning | Says Ingress NGINX is retired/not being developed and recommends Gateway API for new deployments | SOURCE FACT — README |
| Chart metadata | appVersion 1.15.1; chart version 4.15.1 | SOURCE FACT — charts/ingress-nginx/Chart.yaml |

The user-supplied repository-page snapshot also displayed zero stars, zero watchers, zero forks, no published releases, and “No contributors.” These UI observations are retained as USER-SUPPLIED SNAPSHOT facts; the “No contributors” display is not proof that no upstream contributors authored the inherited code.

## Maintenance interpretation

The fork was created after the upstream project had already reached its retirement period. The current main head is an upstream-authored release commit, not evidence of a downstream security-maintenance program. The fact that the downstream repository itself is not marked archived does not restore upstream support or guarantee fixes.

## Important workflow observation

The inherited `.github/workflows/vulnerability-scans.yaml` uses Trivy with `exit-code: 0`. It can produce SARIF findings, but that setting does not make discovered vulnerabilities a failing release gate. A scan workflow is not proof that an image is safe, and scanning upstream registry images is not a substitute for testing the exact downstream artifact.

The branch head is reported as unprotected. Repository rulesets/branch-protection settings were not fully inspected in this assessment because the GitHub integration could not read the protection endpoint. The branch listing itself reported `protected: false`.

## Not verified

- A downstream build from this fork.
- A downstream image or chart publication.
- Current cluster compatibility.
- A vulnerability scan of a locally built image or deployed workload.
- A downstream security contact or response SLA.
- All contributors across the complete Git history.
- A Kubernetes cluster, its version, network model, cloud provider, or existing Ingress inventory.

## Repository locations inspected

- `README.md`
- `SECURITY.md`
- `SECURITY_CONTACTS`
- `OWNERS`
- `GOLANG_VERSION`
- `charts/ingress-nginx/Chart.yaml`
- `.github/dependabot.yml`
- `.github/workflows/ci.yaml`
- `.github/workflows/vulnerability-scans.yaml`

No upstream source code was changed by this overlay.
