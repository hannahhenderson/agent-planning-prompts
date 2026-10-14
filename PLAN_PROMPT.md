# Plan prompt — Claude Code and Codex

> In Plan mode: use `$WORK_KIND` from `$TRACKER` (or `none`); default `$PLAN_FILE` to `PLAN.md`. **Do not implement.** Save only the approved plan, switching to a writable mode if necessary.

## Ask first: refactoring appetite

Unless answered already, ask: **Minimal** (smallest safe complete change, optional refactors separately), **Opportunistic** (contained refactors with clear payoff), or **Refactor-friendly** (broader work when full benefits exceed cost)? Recommend Minimal for shared/work and Opportunistic for personal repos, but do not assume. Record `Refactoring appetite: Minimal | Opportunistic | Refactor-friendly`. Without an answer, offer a provisional minimal plan; **do not implement**.

## Plan valuable outcomes

Read repo rules (`AGENTS.md`/`CLAUDE.md`), tracker issues/comments, code, tests, dependencies, and open PRs. Distinguish the **user outcome** from the proposed solution. Find already-solved, unnecessary, duplicate, or conflicting work. Prefer no change, existing functionality, or narrower scope when sufficient.

Choose the smallest **complete** approach with clear inputs, local state, isolated effects, and manageable blast radius. Consider an alternative for material choices; account for tests, integration, maintenance and review/coordination cost. Honor the selected refactoring appetite. Prioritize correctness/security and user impact, then dependencies, value, regression risk and review effort.

## Impact screen: brief unless risk warrants detail

For each dimension mark **none / applicable** with a reason; expand applicable areas into verifiable mitigations and human decisions:

1. **User experience and rollout:** user journey, partial exposure, mixed clients, errors/accessibility, communications, observability, stop/mitigation criteria and rollout owner as appropriate.
2. **Data and migrations:** schema/API compatibility, staged changes/backfill, integrity, idempotency, partial failure, scale/locking and *realistic* rollback or roll-forward. Identify destructive steps.
3. **Security, abuse and privacy:** trust boundaries, authentication/authorization and tenant isolation, sensitive data and logs, misuse and input handling. For resource-intensive/user-triggered behavior, propose **server-side** rate, size, concurrency or spend limits with clear user-facing errors and a way to raise them.
4. **Operational impact:** retry/concurrency failure modes, dependencies, performance and cost if the change could materially affect them.

Use project conventions and proportional rigor; no automatic threat model, dashboard or runbook for an unaffected area. **Planning a production action never authorizes executing it.**

## Write the approved `$PLAN_FILE`

At the top: **outcome**, `Refactoring appetite: ...`, scope exclusions, impact screen, end-to-end acceptance evidence, critical path and human-owned rollout/migration gates if any.

For each reviewable implementation item include:

- Stable ID and issue URL; intended observable behavior and priority.
- Smallest complete approach, affected files/contracts, dependencies, invariants, and explicit scope boundaries.
- Acceptance criteria, failure cases, reproducible checks (including integration/rollout/data/security checks when applicable), and low/medium/high risk.
- Cohesive PR boundary and dependency order; human decisions; exactly one parseable `Status: todo` line.

Preserve status strings exactly: `Status: todo`, `Status: in progress`, `Status: done`, `Status: blocked`. Do not label code review readiness as deployment readiness.

Aim for roughly **three high-value PR reviews per batch**, **not a cap**; never compromise PR boundaries to meet it. Decide routine reversible choices autonomously; escalate material product, security, architecture, compatibility, scope or irreversible decisions.

**Present the plan for approval without implementing**, with critical risks and one clear next action.
