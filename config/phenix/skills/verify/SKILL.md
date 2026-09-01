---
name: verify
description: "Independently audit whether a completed candidate satisfies its contract after deterministic maintenance passes. Use when asked to verify, validate, confirm, prove, check completion criteria, or before a final completion or merge claim. Verification is read-only and returns findings; it does not repair failures."
---

Audit the exact candidate revision with fresh context. Do not inherit the implementation worker's reasoning, plan, self-review, or claims of completeness.

## Inputs

Require:

- objective/spec and acceptance criteria;
- base and head revisions;
- full diff and repository state;
- relevant repository documentation;
- exact maintenance flake command result for the head revision.

If maintenance has not passed for the candidate revision, return `blocked`. Do not substitute an LLM judgment for the deterministic gate.

## Audit

1. Build an acceptance map: criterion -> implementation evidence -> test/evidence -> verdict.
2. Inspect the diff and surrounding code for missing wiring, unreachable implementation, stale compatibility paths, and behavior that narrows or contradicts the contract.
3. Inspect relevant docs and examples for contradictions, stale names/paths/config keys/APIs, missing updates, and references to superseded architecture.
4. Check negative and failure behavior when the contract includes rejection, authority, recovery, persistence, or lifecycle semantics.
5. Treat maintenance results as facts. Investigate semantic gaps the deterministic checks cannot establish.
6. Re-check evidence invalidated by any source change. Verification applies only to the exact head it inspected.

## Evidence rules

- A passing command proves only what that command exercises.
- Existing green tests do not prove new behavior unless their assertions cover it.
- A mocked path does not prove a real integration boundary when the criterion requires integration.
- Manual inspection is valid evidence for explicit structural claims.
- Maintenance status is evidence only for the exact revision it ran against.
- Every required criterion must map to concrete evidence. An unmapped criterion is a blocking finding.

## Verdict

Return one of:

- `pass`: maintenance passed and every required criterion is accounted for with no blocking semantic finding;
- `fail`: one or more blocking findings contradict or leave the contract unimplemented;
- `blocked`: required source, spec, docs, or maintenance evidence is unavailable.

Findings are concise and evidence-backed:

```text
severity: blocking | warning
criterion: <id or description>
location: <file/symbol/reference>
evidence: <observed fact>
problem: <contract or documentation mismatch>
expected: <required state>
```

Return findings to `implement`. Do not edit files, weaken criteria, or manufacture a pass.
