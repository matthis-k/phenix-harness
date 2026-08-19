---
name: grilling
description: Stress-test a plan, decision, or idea through structured interview. Use when the user wants to pressure-test thinking before acting.
---

Interview the user until every decision is settled. Map the conversation as a **design tree**: each decision branches into the decisions that depend on it.

## Rounds

Work the tree in rounds. The **frontier** is every decision whose prerequisites are already settled. These are the questions you can ask now. Ask the whole frontier in one round. Number each question and give your recommended answer. Wait for the user's answers before the next round.

Each round, the user's answers reshape the tree. Settled decisions push the frontier outward and unblock the next layer. Recompute the frontier and ask again. A question whose answer depends on another open question belongs to a later round.

## Question format

Each question follows this structure:

```
**Q<number>** - **<title>**: <body, may include multiple choices>

Recommendation: <your recommended answer>
```

## Fact-finding

Finding facts is your job, never the user's. When a frontier question needs a fact from the environment, look it up in the codebase, tests, or documentation. Don't block the round on it. Only the questions downstream of the lookup wait. Ask the rest of the frontier now. The decisions are the user's.

## Completion

The session is done when the frontier is empty. Every branch visited, nothing left silently assumed. Do not act on the decisions until the user confirms shared understanding.
