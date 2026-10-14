# Plan prompt — Claude Code and Codex

> Use in **Plan mode**. Replace `$WORK_KIND`, `$TRACKER`, and `$PLAN_FILE`. If no tracker is used, replace `$TRACKER` with `none`. The plan should be saved only after approval in a write-enabled mode.

I have $WORK_KIND issues in $TRACKER for this repository. Create an implementation plan to save as $PLAN_FILE after my approval. **Do not implement anything.**

## Required first question: refactoring appetite

Before proposing implementation, ask:

> How much refactoring is in scope for this run: **Minimal** (smallest safe complete patch; optional refactors separately), **Opportunistic** (contained refactors with clear benefit), or **Refactor-friendly** (broader refactors if total benefit outweighs implementation, validation, review and coordination cost)?

Recommend **Minimal** for shared/work repositories and **Opportunistic** for personal projects, but **always ask** unless the user already explicitly answered. Do not infer the answer. Record `Refactoring appetite: Minimal | Opportunistic | Refactor-friendly` in the approved plan. If unanswered, present conservative provisional alternatives but do not begin implementation or silently authorize optional refactoring.

## Objective

Maximize valuable, correct, **locally understandable and independently verifiable outcomes per unit of human review effort**, preserving security, maintainability, compatibility, and existing intended behavior. Prefer a few exceptionally well-validated changes over many weak ones. Do not optimize for issue count, PR count, code volume, or agent activity.

## Discover

1. Read repository instructions (`AGENTS.md`, `CLAUDE.md`), relevant code, architecture, and existing test commands.
2. Inspect requested tracker issues, comments, dependencies, and open PRs. Identify duplicate, obsolete, already-solved, contradictory, and underspecified work.
3. Treat the tracker as the source of requested scope, not an infallible implementation specification. If no tracker exists, use my request to define the initial queue, then use the approved plan as its source of truth.
4. Identify shared files, customer-visible transitions, existing data/schema compatibility, API compatibility requirements, trust boundaries, and likely conflicts between tasks.

## Screen every plan for production and user impact

Record a brief **Impact screen** with `none / applicable` for each of these areas. For an applicable area, provide a concrete plan proportional to risk, including evidence and responsible human decisions. "None" must be supported by the scope rather than assumed.

1. **End-user experience and rollout.** What changes for users during and after release, including partial rollout, existing sessions/clients, error/empty/loading states, accessibility, onboarding or communication, and an interrupted or disabled feature? For consequential changes specify exposure strategy (flag, cohort, phased launch if useful), health signals, owner, stop conditions, and mitigation/rollback. Do not equate a merged PR with a shipped experience.
2. **Data lifecycle and migrations.** Does the work modify persistent formats, schemas, indexes, data meaning, storage, or retention? Check old/new-version compatibility, safe sequencing (e.g. expand -> backfill -> contract where appropriate), production scale/locking/load, idempotency, partial failure, verification of integrity, and realistic recovery. Destructive steps or data rewrites may require roll-forward rather than an assumed reversible rollback.
3. **Security, abuse resistance and privacy.** Identify trust boundaries, sensitive data, identities, authorization and tenant isolation, untrusted input/output, secrets, least privilege, logging/retention, and credible misuse. Ask how users could automate, repeat, amplify, or accidentally overload new behavior. For operations with meaningful variable cost or resource use, define server-enforced limits (rate, size, concurrency, runtime, spend as applicable), conservative defaults, observability, and a clear legitimate path to higher limits. All changes should preserve existing protections; for affected/high-risk areas add a brief threat model and explicit misuse/security tests.

The plan can define a **human-owned** rollout/migration runbook and approval gates, but autonomous execution remains limited to authorized branches, local/test environments and draft PRs. Production changes, access changes and irreversible steps require explicit authorization.

## Challenge the work before making a backlog

Separate desired outcomes from tracker-proposed solutions. Identify work to delete, skip, combine or defer, including already-implemented features. Evaluate existing helpers and platform features before inventing infrastructure.

For material choices, compare the smallest complete patch to a genuinely different solution. Judge blast radius, dependency and state locality, side effects, testability, compatibility, total context to understand the result, and **all** implementation, testing, review and coordination costs. Favor explicit dependencies, confined side effects, and abstractions only when they reduce reasoning context. Do not perform a broad refactor simply because the code is imperfect. Follow the selected appetite and seek approval for material scope expansion.

## Prioritize

First prioritize urgent security/correctness/operational risk, then user impact, dependencies and unblock potential, expected value vs. total effort, regression risk, and **human review burden**. Choose PR boundaries around cohesive behavior, not a numerical PR target. Explain meaningful tradeoffs. Favor high-value independent tasks when risk is comparable.

## In $PLAN_FILE, include for the overall run

- Selected `Refactoring appetite: ...`, desired user-visible outcome, end-to-end acceptance check, and **Impact screen** (rollout UX, data/migrations, security/privacy), with `none` or applicable safeguards
- Work that should not be implemented and why; the critical path, PR dependency order, integration validation, and human-owned release or data migration gates where applicable
- The roughly three highest-value expected human review actions as a **guideline**, not a cap

## For each item, include

- Stable ID; tracker issue URL, if any
- Problem, supporting evidence, and intended outcome
- Priority and rationale
- Proposed smallest complete implementation, material alternative considered, and likely affected files
- Dependencies and sequence
- Scope boundaries, existing callers/contracts, side effects, state dependencies, and behavior that **must not change**
- Objective acceptance criteria and definition of done; distinguish code/PR readiness from production rollout readiness
- Reproduction or failing test when practical; regression and failure-case tests
- Validation commands, objective observed evidence at local and cross-boundary levels, and an integration check for dependent PRs
- Complexity and regression risk (`low`, `medium`, `high`)
- Proposed PR boundary, stacked dependencies if any, and expected human review burden
- Whether independent delegation is useful and safe
- Decisions requiring human approval, including rollout exposure, destructive data steps, and security/permission changes
- Exactly one parseable line: `Status: todo`

Use the exact strings `Status: todo`, `Status: in progress`, `Status: done`, `Status: blocked` throughout the plan; external scripts may parse them.

## Autonomy

Treat routine reversible implementation choices as agent decisions, within the approved refactoring appetite. Record material assumptions. Ask me only when an unresolved decision materially affects product behavior, security, public interfaces, irreversible actions, scope, or architecture. Do not invent requirements. Explicitly flag production rollouts, destructive operations, schema/data migrations, authorization changes, sensitive data flows, or secrets-related work.

## Before finishing

Show a recommended first review batch (aim for about three, not a limit), critical path, safe delegation opportunities, risk-tiered verification, and any essential human questions. Keep the plan understandable to an engineer who did not see this conversation. **Present it for approval without starting implementation.** If Plan mode cannot write files, tell me the shortest next step to save the approved plan as $PLAN_FILE.

End with one concrete action for me, in the format described by the `i-have-adhd` skill if activated.
