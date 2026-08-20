---
name: tdd
description: Develop behavior through small red-green cycles at stable interfaces. Use for features, bug fixes, regression tests, or when the user asks for test-first work.
---

# Test-driven development

Use tests to lock behavior while keeping implementation replaceable.

Read `GLOSSARY.md` when it exists so test names use canonical project terms. Use `codebase-design` when the correct interface or seam is itself part of the problem.

## Test seam

Choose the highest stable interface that directly observes the behavior under change.

Prefer seams that callers already use. Do not create a public interface only to make a test easy.

If several seams are plausible, choose the one most likely to survive an internal rewrite and state the choice in the implementation plan.

## Good tests

A good test:

- describes externally meaningful behavior;
- fails for the intended missing behavior before production code changes;
- has an expected result independent of the implementation;
- survives internal restructuring;
- keeps setup proportional to the behavior being tested;
- uses canonical domain language.

## Anti-patterns

- **Implementation coupling**: private methods, internal call order, or object layout are part of the assertion.
- **Tautology**: the test recreates the implementation to compute the expected value.
- **Horizontal slicing**: many speculative tests are written before any behavior is implemented.
- **Mock-heavy structure**: mocks mirror internal collaborators and make refactors rewrite the test suite.
- **Broad snapshot**: a large snapshot replaces a small semantic assertion.
- **Test weakening**: assertions, setup, or coverage are relaxed because the implementation cannot satisfy the original behavior.
- **Test-only API**: production interfaces grow only to expose internal state to tests.

## Loop

Work in vertical slices:

1. **Red**: add one focused test for one missing behavior. Run it and prove it fails for the intended reason.
2. **Green**: make the smallest coherent production change that satisfies the behavior. Do not anticipate unrelated future cases.
3. **Check**: run the focused test and the nearest relevant surrounding tests.
4. **Continue**: add the next behavior only after the current slice is understood.

For bugs, reproduce the failure first when practical. The regression test should fail on the unfixed code and pass on the repaired code.

## Architecture pass

Green is not the end of the work.

After the behavior is covered, review the implementation with `codebase-design` and `code-review` when the change is architectural or non-trivial. Refactor or rewrite the implementation if that produces a cleaner end state while keeping behavior tests green.

Prefer replacing obsolete tests with tests at the stronger interface rather than layering new tests over every old internal seam.

## Validation

Run validation from narrow to broad:

1. focused test;
2. affected module or package tests;
3. repository checks relevant to the change;
4. full deterministic suite when the project normally requires it.

Do not claim success from a broad green suite when the focused regression was never proven red first.

## Completion check

The work is complete when:

- each new behavior has durable coverage at a stable interface;
- bug regressions were reproduced before repair when practical;
- tests do not encode replaceable implementation structure;
- architecture cleanup kept the same behavior tests green;
- no test was weakened to accommodate the implementation.
