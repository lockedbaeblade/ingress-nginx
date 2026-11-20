# Gateway Migration Test Evidence Record

**Status:** TEMPLATE — no tests are claimed to have run.

| Field | Value |
|---|---|
| Evidence ID | TBD |
| Gate / test case | TBD |
| Environment / cluster | TBD |
| Kubernetes version | TBD |
| CNI/version | TBD |
| Gateway controller/version | TBD |
| Source commit | TBD |
| Image digest(s) | TBD |
| Operator / reviewer | TBD |
| Execution timestamp + timezone | TBD |
| Result | NOT RUN |
| Raw output location | TBD |
| Defect / exception | TBD |
| Exception owner + expiry | TBD |
| Approval reference | TBD |

## Test procedure
1. State the exact preconditions and test data.
2. Record the exact command/API request without secrets.
3. Capture raw output and relevant Gateway/HTTPRoute conditions.
4. Record expected and actual results.
5. For security tests, record the server-side PAE decision and whether protected data was retrieved.
6. Repeat across replicas where applicable.
7. Record cleanup and recovery steps.

## Result rules
- PASS: test executed and expected security/functional behavior observed.
- FAIL: test executed and acceptance criteria not met.
- PARTIAL: some assertions passed; gaps remain.
- NOT RUN: no execution evidence.
- NOT APPLICABLE: reason and approver recorded.

Do not convert a design review, manifest parse, or controller-ready status into a PASS for runtime behavior.