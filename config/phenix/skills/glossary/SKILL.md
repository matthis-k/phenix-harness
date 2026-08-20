---
name: glossary
description: Maintain a repository's GLOSSARY.md as the canonical vocabulary for domain and architectural concepts. Use when terms are introduced, renamed, overloaded, clarified, or found to disagree across code and documentation.
---

# Glossary

`GLOSSARY.md` defines the current canonical language of the repository. Keep it small, normative, and synchronized with the code.

## Read first

Before architecture-sensitive work, read `GLOSSARY.md` when it exists. Use its terms in plans, code, APIs, tests, and documentation.

A conflict between the glossary and the code is evidence, not an automatic verdict. Determine which one is stale before changing either.

## Core invariant

One concept gets one canonical term. One canonical term names one concept.

When several names describe the same thing, choose one and remove the others from active use. When one name hides several distinct concepts, split them and name each one precisely.

## What belongs

Add a term when its meaning is specific to the repository and a reader could reasonably confuse it with another project concept.

Good entries include:

- domain entities and operations;
- architectural roles with project-specific ownership;
- session, routing, provider, protocol, or lifecycle concepts whose distinctions matter;
- names whose synonyms have already caused drift.

Skip ordinary programming terms unless the project gives them a special meaning.

## Entry format

Use only fields that add information:

```md
## Provider

A source of models and authentication capabilities.

Owns: provider identity, model discovery, supported authentication methods.

Does not own: Phenix session lifecycle or routing policy.

Distinct from: Backend, Model.

Avoid: provider runtime, backend provider.
```

Definitions should be one or two sentences. Ownership fields are useful only when they prevent a real ambiguity.

## Maintenance rules

1. **Update inline.** When a term is settled during design or implementation, update `GLOSSARY.md` in the same change.
2. **Prefer reuse.** Before adding a term, check whether an existing entry already names the concept.
3. **Keep current state only.** The glossary describes the intended architecture now. Do not turn it into migration history.
4. **Remove stale names.** After a rename or rewrite, update code, tests, docs, configuration, and the glossary together where practical.
5. **Use `Avoid` sparingly.** List a synonym only when it is likely to recur and naming it helps prevent drift. Do not keep every historical name.
6. **Keep implementation detail out.** The glossary explains meanings and ownership, not algorithms, file layouts, or step-by-step behavior.
7. **Keep decisions elsewhere.** Put durable tradeoff rationale in an ADR when the decision is hard to reverse, surprising without context, and based on a real alternative.

## Drift review

When reviewing terminology, search code, tests, docs, config, protocol names, and user-facing labels for:

- canonical terms used with conflicting meanings;
- synonyms for one concept;
- obsolete names after a rewrite;
- names whose ownership contradicts their glossary entry;
- new nouns introduced without a distinct concept behind them.

Do not fix naming only in documentation. The repository and glossary should converge on the same language.

## Completion check

A glossary change is complete when:

- the entry distinguishes the concept from its nearest neighbors;
- active code and documentation use the canonical term where the change is in scope;
- stale aliases are removed unless a concrete compatibility constraint requires them;
- any compatibility alias has a named consumer and deletion condition.
