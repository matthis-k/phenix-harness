---
name: ship
description: "Take a completed change through PR readiness and integration. Use when the user asks to ship, finish a PR, prepare or update a PR, handle review feedback, get CI green, rebase for merge, make a branch merge-ready, or merge completed work. Use after implementation; do not use to select the next unrelated PR or objective."
---

Integrate the exact assigned change. Shipping does not broaden scope.

## Start

1. Recover the PR or branch objective, acceptance criteria, dependencies, current head, base branch, review state, maintenance state, and independent verification state.
2. Compare the branch with its base. Identify unrelated changes, missing commits, stale base assumptions, and unresolved review threads.
3. Confirm the PR description still states the implemented contract and dependencies accurately.

## Ready the PR

1. Ensure the repository's maintenance flake command runs against the actual head. If draft state suppresses required CI, mark actively worked PRs ready before relying on the result.
2. Rebase or update onto the intended base when required. Any source change invalidates prior maintenance and verifier evidence.
3. If maintenance fails, route the failure to `implement`, repair it, and rerun maintenance.
4. After maintenance passes, run a fresh independent `verify` audit against the same head. Route blocking findings to `implement`; after repairs rerun maintenance and a fresh verifier.
5. Resolve blocking review findings inside the assigned scope through the same completion loop.
6. Keep the PR description current with dependencies, completed scope, and decisive evidence.

While manual maintenance/CI approval is pending, keep auditing and implementing remaining objective/spec gaps. Stop for approval only when no substantive work remains and the external approval is the sole blocker.

## Merge gate

Merge only when:

- the assigned objective is complete;
- the maintenance flake command passed for the exact merge candidate;
- the independent verifier passed for that same candidate;
- blocking review findings are resolved;
- the branch is based on the intended parent/base;
- no unrelated work has entered the change.

If any gate fails, keep working the same PR when repair is possible. Report only the concrete external blocker when no substantive work remains.

## Boundary

Do not select, open, or advance to another PR after shipping. PR selection belongs to the caller's startup/coordination phase. One worker stays on one selected PR for its lifetime.
