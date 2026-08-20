---
name: code-review
description: Review a change independently for requested behavior, architecture, and code quality. Use for PRs, branches, work in progress, or any request to assess whether a change is correct and clean enough to keep.
---

# Code review

Review three axes separately so one does not hide another:

- **Contract**: does the change implement the request, specification, and acceptance criteria?
- **Architecture**: does it move the repository toward one coherent ownership model and intended end state?
- **Code quality**: is the implementation clear, local, testable, and free of avoidable duplication or speculative structure?

Read repository standards, `GLOSSARY.md`, and relevant ADRs before judging conventions or ownership.

## Establish the change

Use the user-provided base when available. Otherwise compare against the branch merge base with its intended target.

Inspect the diff, affected callers, tests, and relevant surrounding code. A diff can only be judged correctly in its execution context.

## Contract axis

Check for:

- missing or partial requirements;
- behavior that contradicts the request;
- unrequested scope that changes semantics or public contracts;
- weakened validation or tests used to make the change pass;
- regressions in adjacent behavior implied by the same contract.

Prefer observable evidence over inferred intent.

## Architecture axis

Use `codebase-design` as the shared architecture discipline.

Check for:

- duplicate authorities for one responsibility;
- old and new public paths remaining active together;
- compatibility aliases or fallbacks without a named consumer;
- shallow wrappers and forwarding modules;
- seams with no real variation;
- policy duplicated across callers;
- ownership split across unrelated modules;
- domain or architecture terms that conflict with `GLOSSARY.md`;
- migration code with no deletion condition;
- tests that make an internal rewrite unnecessarily expensive.

A green change can still fail this axis.

Do not reward a smaller diff when it preserves a worse architecture. If the clean fix is a bounded rewrite, recommend the rewrite.

## Code quality axis

Treat these as heuristics, not automatic failures. Repository conventions override them.

- **Mysterious name**: a name does not reveal the concept it represents. Rename it. If no precise name exists, inspect the design.
- **Duplicated logic**: the same decision appears in several places. Move the policy to one owner.
- **Data clump**: the same related values travel together repeatedly. Consider a type that represents the concept.
- **Stringly typed concept**: strings or unvalidated maps represent a domain concept with meaningful invariants. Prefer a type or parser that makes invalid state harder to represent.
- **Repeated branching**: several sites branch on the same kind or mode. Concentrate the decision.
- **Shotgun change**: one behavior change requires unrelated edits across many modules. Improve locality.
- **Divergent module**: one module changes for unrelated reasons. Split by ownership when that reduces caller complexity.
- **Speculative generality**: hooks, interfaces, parameters, or configuration exist for no current requirement. Delete or inline them.
- **Middle man**: a function or module mostly forwards calls. Apply the deletion test.
- **Message chain**: callers navigate several internal objects to perform one operation. Hide that traversal behind the owning module.
- **Boolean mode growth**: multiple flags create implicit states or invalid combinations. Replace them with explicit variants or types.
- **Fallback accumulation**: error recovery silently tries old paths or alternate meanings. Keep one canonical behavior unless fallback semantics are part of the contract.

Skip style issues that deterministic tooling already enforces unless the tool is misconfigured.

## Tests

Tests should verify behavior through stable interfaces.

Flag tests that:

- assert private structure rather than observable behavior;
- require changing when internals are reorganized without behavior changes;
- duplicate implementation logic to calculate the expected result;
- overuse mocks where a stable local substitute exists;
- snapshot broad output when a small semantic assertion would be clearer;
- miss the regression path that motivated the change.

## Findings

For each finding include:

- axis;
- severity;
- concrete evidence;
- why it matters;
- smallest coherent fix;
- whether the fix should delete, rewrite, consolidate, refactor, or extend code.

Order findings by severity within each axis. Keep the axes separate in the final report.

## Completion check

A change is clean enough to keep when:

- requested behavior is supported by evidence;
- each responsibility has one authority;
- no unnecessary compatibility path remains;
- public interfaces expose only concepts callers need;
- tests permit internal rewrites;
- names match `GLOSSARY.md`;
- any remaining migration path has a concrete consumer and deletion condition.
