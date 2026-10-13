# Plan prompt — Claude Code and Codex

> Use in **Plan mode**. Replace `$WORK_KIND`, `$TRACKER`, and `$PLAN_FILE`. If no tracker is used, replace `$TRACKER` with `none`. The plan should be saved only after approval in a write-enabled mode.

I have $WORK_KIND issues in $TRACKER for this repository. Create an implementation plan to save as $PLAN_FILE after my approval. **Do not implement anything.**

## Objective

Maximize valuable, correct, independently reviewable engineering progress while preserving security, maintainability, compatibility, and existing intended behavior. Do not optimize for issue count, PR count, or agent activity.

## Discover

1. Read repository instructions (`AGENTS.md`, `CLAUDE.md`), relevant code, architecture, and existing test commands.
2. Inspect requested tracker issues, comments, dependencies, and open PRs. Identify duplicate, obsolete, already-solved, contradictory, and underspecified work.
3. Treat the tracker as the source of requested scope, not an infallible implementation specification. If no tracker exists, use my request to define the initial queue, then use the approved plan as its source of truth.
4. Identify shared files, migration risks, API compatibility requirements, and likely conflicts between tasks.

## Prioritize

First prioritize urgent security/correctness/operational risk, then user impact, dependencies and unblock potential, expected value vs. effort, regression risk, and PR reviewability. Explain meaningful tradeoffs. Favor high-value independent tasks when risk is comparable.

## In $PLAN_FILE, include for each item

- Stable ID; tracker issue URL, if any
- Problem, supporting evidence, and intended outcome
- Priority and rationale
- Proposed implementation and likely affected files
- Dependencies and sequence
- Scope boundaries and behavior that **must not change**
- Objective acceptance criteria and definition of done
- Reproduction or failing test when practical; regression and failure-case tests
- Validation commands and evidence required
- Complexity and regression risk (`low`, `medium`, `high`)
- Proposed PR boundary and expected review burden
- Whether independent delegation is useful and safe
- Decisions requiring human approval
- Exactly one parseable line: `Status: todo`

Use the exact strings `Status: todo`, `Status: in progress`, `Status: done`, `Status: blocked` throughout the plan; external scripts may parse them.

## Autonomy

Treat routine reversible implementation choices as agent decisions. Record material assumptions. Ask me only when an unresolved decision materially affects product behavior, security, public interfaces, irreversible actions, scope, or architecture. Do not invent requirements. Explicitly flag destructive operations, schema migrations, authorization changes, or secrets-related work.

## Before finishing

Show the recommended first batch, critical path, safe delegation opportunities, major risks, and any essential human questions. Keep the plan understandable to an engineer who did not see this conversation. **Present it for approval without starting implementation.** If Plan mode cannot write files, tell me the shortest next step to save the approved plan as $PLAN_FILE.

End with one concrete action for me, in the format described by the `i-have-adhd` skill if activated.
