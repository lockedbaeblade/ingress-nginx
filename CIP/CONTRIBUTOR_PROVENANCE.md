# Contributor, copyright, and source provenance register

**Assessment date:** 2026-11-18

## Repository ancestry

- Downstream repository: `lockedbaeblade/ingress-nginx`.
- GitHub identifies it as a public fork of `kubernetes/ingress-nginx`.
- Upstream repository is archived; the downstream fork's writable/unarchived state does not transfer upstream maintainership or project stewardship.

## Verified commit observation

The inspected `main` head is:

- Commit: `dbb11b92ddb77bee9c35e462479129354c84f939`
- Message: `Release controller v1.15.1/v1.14.5/v1.13.9 & chart v4.15.1/v4.14.5/v4.13.9. (#14738)`
- Commit author identity shown by GitHub: `Gacko`
- Commit timestamp: 2026-03-19
- GitHub signature verification: `verified`

This establishes GitHub's verification result for this commit. It does not prove that the fork owner authored the upstream code, owns all code, has rights beyond the applicable license, or has established an independent security program.

## Inherited attribution material

The upstream-origin files inspected contain:

- `OWNERS`: upstream maintainer/reviewer group names and emeritus approvers.
- `SECURITY_CONTACTS`: inherited upstream contacts, together with explicit instructions not to report vulnerabilities directly to those names and to use the Kubernetes security reporting process.
- `charts/ingress-nginx/Chart.yaml`: inherited chart maintainer names `cpanato`, `Gacko`, `strongjz`, and `tao12345666333`.
- Git history and signed commits: author/committer identities remain part of the upstream provenance.

These inherited entries must not be presented as confirmed maintainers, security responders, or authorized agents for the downstream fork.

## The "No contributors" UI display

The supplied GitHub page snapshot displayed “No contributors.” This may reflect how GitHub renders a newly created fork or calculates displayed contributor statistics. It is not a complete authorship register and does not negate the Git commit history, upstream OWNERS file, or copyright notices.

The full contributor graph/history has not been exhaustively enumerated in this assessment. Do not invent a complete list or treat the latest commit author as the only contributor.

## Required attribution rules for downstream work

1. Keep the upstream Apache-2.0 LICENSE and copyright notices intact.
2. Do not remove or rewrite upstream author/committer history.
3. Put downstream changes in clearly scoped commits and directories.
4. Record, for every downstream change: source commit/tree, contributor identity as asserted by Git, reviewer, date, purpose, files changed, tests, and approvals.
5. Do not claim authorship, ownership, assignment, or exclusive rights based only on a GitHub account, fork relationship, commit signature, timestamp, or SHA-256.
6. Maintain a downstream security contact only after a real contact and response procedure are assigned and tested.

## Downstream ownership and support

**UNKNOWN:** legal ownership of the upstream-origin code beyond the published license; contributor agreements for any downstream changes; a named downstream security response team; and any independent maintenance commitments.

This register is provenance documentation, not a legal opinion.
