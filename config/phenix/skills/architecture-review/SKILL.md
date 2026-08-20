---
name: architecture-review
description: Review a codebase or change for architectural friction, duplicate authority, shallow modules, stale migration code, and better rewrite targets. Use when the user asks to improve architecture or assess whether current structure should be kept.
---

# Architecture review

Find architecture that makes future changes harder than necessary. Prefer a coherent replacement over preserving accidental structure.

Use `codebase-design` for shared architecture rules. Read `GLOSSARY.md` and relevant ADRs before judging names, ownership, or seams.

## Scope

If the user names an area, stay there. Otherwise inspect recent history first and focus on code that changes repeatedly. Architecture work pays most where change is active.

Trace complete behavior paths, not isolated files. Read callers, owners, tests, configuration, and adapters around each candidate.

## Look for

- two modules owning the same policy or state;
- old and new APIs both remaining authoritative;
- pass-through wrappers that add names without hiding decisions;
- concepts split across many files with no clear owner;
- one logical change requiring edits across unrelated modules;
- aliases or renamed concepts that still coexist;
- fallback paths kept without a current consumer;
- abstractions added for hypothetical implementations;
- tests coupled to internal structure;
- migration code whose migration has already finished;
- branch-heavy code repeating the same policy in several places;
- data that travels together but has no domain type;
- modules whose interface exposes implementation choices callers should not need.

Apply the deletion test to suspected shallow modules. For duplicate authorities, identify which one should remain before proposing edits.

## Evaluate candidates

For each material candidate, report:

1. **Evidence**: concrete files, call paths, or repeated changes.
2. **Current ownership**: who owns the behavior now, including overlap.
3. **Target ownership**: the single intended owner.
4. **Change**: delete, merge, rewrite, or refactor. Prefer that order when outcomes are equivalent.
5. **Validation**: the stable behavior or interface that proves the change preserved intent.
6. **Cost**: migration work, external compatibility, or other real constraints.
7. **Strength**: `Strong`, `Worth exploring`, or `Speculative`.

Rank candidates by recurring friction removed, not by amount of code changed.

## Rewrite policy

Do not assume a smaller diff is safer.

A rewrite is preferred when preserving the existing structure would require parallel authorities, forwarding layers, compatibility aliases, duplicated tests, or concepts that exist only to bridge old and new designs.

Incremental migration is preferred when a concrete external consumer cannot move atomically. Name that consumer and the condition that allows the temporary path to be deleted.

Every temporary path needs a deletion condition. Without one, treat it as permanent architecture and judge it accordingly.

## After a candidate is chosen

Use `codebase-design` to settle the target interface and seam placement. Use `grilling` when product or architecture decisions remain unresolved.

If the change adds, removes, renames, or sharpens an architectural concept, use `glossary` in the same change.

Do not implement during a review unless the user asked for implementation.
