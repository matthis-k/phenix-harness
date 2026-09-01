---
name: ship
description: "Take a completed change through PR readiness and integration. Use when the user asks to ship, finish a PR, prepare or update a PR, handle review feedback, get CI green, rebase for merge, make a branch merge-ready, or merge completed work. Use after implementation; do not use to select the next unrelated PR or objective."
---

Integrate the exact assigned change. Shipping does not broaden scope.

## Start

1. Recover the PR or branch objective, acceptance criteria, dependencies, current head, base branch, review state, and prior verification.
2. Compare the branch with its base. Identify unrelated changes, missing commits, stale base assumptions, and unresolved review threads.
3. Confirm the PR description still states the implemented contract and dependencies accurately.
4. Refresh required CI for the exact current head before choosing the next work item. New CI evidence supersedes stale handoff state.

## CI priority

Treat required exact-head CI as active feedback, not a final reporting step.

1. Any failed required job becomes the current frontier. Inspect the failing job and logs immediately and establish whether the PR caused the failure.
2. If the PR caused the failure, route the repair through `implement`, then `verify` the repair before returning to queued work.
3. If the failure is external or infrastructure-only, record the evidence and continue any independent substantive work that remains.
4. A queued implementation step, pending executor request, intermediate yield, or stale handoff blocker does not outrank a fresh CI failure.
5. Re-evaluate CI after every head change. A state transition invalidates claims such as "CI in progress", "green", or a previously named stop reason.

`action_required` needs classification. Manual CI approval is required user intervention only when the exact current head has no failed required jobs, no incomplete acceptance criteria, no unresolved review findings, and no other repairable or substantive PR work. While approval is pending, keep auditing and implementing remaining PR/spec gaps until none remain.

## Ready the PR

1. Ensure substantive validation runs against the actual head. If draft state suppresses required CI, mark actively worked PRs ready before relying on CI results.
2. Rebase or update onto the intended base when required. Re-verify evidence invalidated by the new source state.
3. Run or inspect all required CI jobs. Treat skipped, cancelled, action-required, or missing jobs according to the repository's actual policy; do not call them green by omission.
4. Resolve review findings inside the assigned scope. Route implementation changes through `implement` and rerun `verify` afterward.
5. Keep the PR description current with dependencies, completed scope, exact-head CI state, and decisive validation evidence.

## Merge gate

Merge only when:

- the assigned objective is complete;
- required acceptance criteria pass;
- required CI is green for the exact merge candidate;
- blocking review findings are resolved;
- the branch is based on the intended parent/base;
- no unrelated work has entered the change.

If any gate fails, keep working the same PR when repair or further substantive progress is possible.

## Stop condition

For an actively worked PR, continue until the PR is merge-ready or manual CI approval is the only remaining blocker. Pending executor requests and other resumable events are not stop conditions by themselves.

## Boundary

Do not select, open, or advance to another PR after shipping. PR selection belongs to the caller's startup/coordination phase. One worker stays on one selected PR for its lifetime.
