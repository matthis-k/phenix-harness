---
name: implement
description: "Own a settled coding change through completion. Use when the user asks to implement, build, fix, change, execute a plan or spec, work on an issue or PR, or continue an existing implementation. Work the entire assigned scope; do not select or advance to unrelated work. Use `grilling`, `architect`, or `plan` first when material intent is still unsettled."
---

Finish the assigned objective, not one convenient subtask.

## Start

1. Recover the exact objective, acceptance criteria, plan or issue, current branch/worktree, prior attempts, and existing changes.
2. Inspect the code and tests at the intended seams before editing. Continue valid prior work instead of recreating it.
3. Identify the current incomplete frontier inside the assigned scope. Do not choose a different issue, PR, or objective.

## Execute

1. Make the smallest coherent change that advances the complete objective.
2. Reuse canonical abstractions. Remove superseded paths when the change establishes a replacement contract.
3. Add or update tests at the strongest stable seam for the requested behavior.
4. Run focused feedback after each meaningful slice. Fix causes, not assertions that expose them.
5. Keep unrelated cleanup out unless it is required to make the requested change correct.
6. When an attempt fails, preserve valid completed work, capture why it failed, and continue from that state.

## Scope discipline

A checklist tracks progress; it does not redefine the objective. Continue through all remaining items that belong to the assigned scope unless blocked by a real decision, unavailable dependency, or external failure.

When a new product or architecture decision appears, stop that branch and route the decision to `grilling` or `architect`. Continue independent settled work when possible.

## Completion loop

1. Run the repository's maintenance flake command against the exact candidate revision.
2. If maintenance fails, repair the failure and rerun it. Maintenance is the deterministic gate.
3. After maintenance passes, invoke an independent read-only verifier with fresh context. Give it the objective/spec, base and head revisions, diff, repository/docs, and exact maintenance result. Do not give it worker reasoning or self-review.
4. If the verifier returns blocking findings, treat them as implementation input. Repair them, rerun maintenance, then invoke a fresh verifier again.
5. Complete only when maintenance passes and the independent verifier passes for the same candidate revision.

For high-risk or structurally significant changes, use `interrogate` before the completion loop.

Return what changed, decisive evidence, and any concrete blocker. Never describe partially implemented scope as complete.
