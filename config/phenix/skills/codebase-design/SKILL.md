---
name: codebase-design
description: Design or restructure code around clear ownership, deep modules, small interfaces, and real seams. Use for architecture work, refactors, interface design, or when deciding whether to delete, merge, or rewrite abstractions.
---

# Codebase design

Design the intended end state first. Existing structure has no claim to survival.

Read `GLOSSARY.md` when it exists. Use its canonical terms in code, tests, plans, and documentation.

## Vocabulary

**Module**: code with an interface and an implementation. Scale does not matter.

**Interface**: everything a caller must know to use a module correctly. This includes types, invariants, ordering, errors, configuration, and relevant performance constraints.

**Implementation**: behavior hidden behind the interface.

**Seam**: a place where behavior can vary without changing callers.

**Adapter**: an implementation selected at a seam.

**Depth**: how much useful behavior a module hides relative to how much callers must understand.

**Locality**: how well one concept's policy, state, failure handling, and verification stay together.

## Rules

1. **Prefer the clean end state.** Choose the architecture you would build if historical structure did not exist. Work backward from that shape.
2. **Delete before adding.** When old and new structures overlap, remove the old authority instead of preserving both.
3. **Rewrite when preservation costs more.** If adapters, fallbacks, aliases, duplicated APIs, or migration code make the target architecture harder to understand, replace the affected code instead. Keep compatibility only for a concrete external constraint.
4. **One responsibility, one authority.** State which module owns each policy or invariant. Competing authorities are an architecture defect.
5. **Make modules deep.** Hide decisions behind a small interface. A wrapper that exposes nearly every underlying choice is shallow.
6. **Use the deletion test.** Imagine removing the module. If complexity disappears, the module was probably pass-through code. If complexity spreads into callers, the module is doing useful work.
7. **Create real seams.** Add a seam when behavior actually varies or an external dependency requires substitution. Do not add an interface for a hypothetical future implementation.
8. **Keep test seams private when possible.** A test dependency does not by itself justify expanding the public interface.
9. **Test through the interface.** Internal rewrites should leave behavior tests unchanged. Tests that require implementation details make structural improvement harder.
10. **Keep concepts local.** Prefer one module that owns a coherent concept over many small files that force callers to reconstruct the concept.
11. **Make invalid states hard to represent.** Put invariants in types and constructors where the language permits it.
12. **Use one canonical path.** New code should not create parallel APIs, fallback paths, or compatibility aliases without a named consumer that requires them.

## Design it twice

For architecture with high rewrite cost, produce at least two materially different designs before implementation. Vary the interface or seam placement, not naming alone.

Compare each design on:

- caller complexity;
- ownership clarity;
- number of exposed concepts;
- locality of change;
- testability through stable interfaces;
- obsolete code it allows you to delete.

Recommend one. A hybrid is valid when it is simpler than either source design.

## Dependency strategy

Classify dependencies before choosing a seam:

- **In-process**: keep inside the module when possible.
- **Local substitute available**: test the module with the substitute without exposing a new public seam.
- **Owned remote dependency**: define a narrow port where transport genuinely varies.
- **External dependency**: inject the smallest interface needed by the module.

## Completion check

Before accepting the design, verify:

- every major responsibility has one owner;
- no obsolete authority remains beside its replacement;
- every seam has a concrete reason to exist;
- callers learn fewer concepts than before;
- behavior tests can survive an internal rewrite;
- `GLOSSARY.md` matches any changed architectural terms.
