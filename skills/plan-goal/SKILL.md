---
name: plan-goal
description: "Reusable Plan → Goal engineering workflow for Claude Code and Codex. Turn repo issues, tech debt, bugs, or features into an approved plan, implement them as independently validated draft PRs, and produce a short actionable morning handoff. Use when asked to plan a backlog, run an approved plan, or resume an autonomous engineering run."
---

# Plan → Goal

Turn high-level goals into **valuable, exceptionally well-validated draft PRs** through recoverable engineering delegation. Optimize for completed outcomes per unit of human review effort, not issue count or PR count.

## Engineering principles

Prefer **safe, local change**: explicit dependencies, isolated side effects, locally understandable state and behavior, and named, testable helpers where useful. Reuse existing conventions. Introduce an abstraction only if it decreases the total context required to understand or modify the system. A short diff is not automatically a small blast radius. Complete all necessary caller, contract, fixture, test, validation, and security work.

Challenge whether requested work needs to exist. Treat user rollout experience, production state transitions, data lifecycle and security boundaries as part of the design when affected. Prefer eliminating unnecessary work, narrowing scope, or using existing functionality. Plan user-visible outcomes, then choose cohesive reviewable PRs. Verify actual behavior, not agent assertions or compilation alone. Favor a small number of exceptionally well-validated PRs with low human review cost.

## When invoked

1. Determine whether the user wants **plan**, **execute**, **resume**, or **review the result**. If their request makes the stage clear, start there without asking.
2. Work on the **target project** selected by the user, not this skill's source repository.
3. Read that project's `AGENTS.md` and `CLAUDE.md` plus any stricter project rules.
4. Apply the relevant bundled instructions below. If the running tool does not expose a mode or command, use its supported equivalent and state the limitation.

| Stage | Read and follow |
| --- | --- |
| Plan | [references/plan.md](references/plan.md) |
| Execute or resume | [references/goal.md](references/goal.md) |
| Any normal exit | [references/morning-handoff.md](references/morning-handoff.md) |

## Plan

**At the beginning of each planning run, ask once about refactoring appetite**, unless the user has already answered explicitly: **Minimal** (smallest safe complete change; optional refactors separately), **Opportunistic** (contained refactors with clear payoff), or **Refactor-friendly** (broader changes whose benefits justify implementation, testing, review and coordination costs). Recommend Minimal for work/shared repositories and Opportunistic for personal projects, but do not infer or choose for the user. Record `Refactoring appetite: ...` in the approved plan and pass it to delegates. If unanswered, present conservative provisional options; do not implement.

Use Plan mode if supported. Gather `WORK_KIND` (bugs, features, tech debt), `TRACKER` (Linear, GitHub Issues, file, or none), and `PLAN_FILE` (default `PLAN.md`) from the user's request. Do not ask for values you can infer safely.

Inspect the code, tracker, tests, dependencies, and existing PRs. Challenge the need for code and the proposed design; screen for customer rollout impact, migration/data compatibility and security/trust boundaries. Evaluate local reasoning, blast radius, review burden, transition safety and end-to-end verification. Require plans for applicable operational risks, not boilerplate for inapplicable ones. Apply `references/plan.md` to produce verifiable, sequenced work items with exact `Status: todo` lines. Present the plan for approval; do not implement yet. If Plan mode is read-only, persist it only after approval in a mode that allows writing.

## Execute or resume

Read `references/goal.md` and the approved plan. For approved legacy plans lacking refactoring appetite, ask once before implementation. The completion condition is **every eligible item backed by a verified draft PR or documented as blocked**, with no unaccounted-for `todo` or `in progress` items in a report claiming complete. Confirm PRs and validation against actual remote state, not status text alone.

If native `/goal` is supported, set this as a concise completion condition and keep detailed execution instructions in the reference. If unavailable, follow the instructions in a normal execution session without promising automatic continuation.

Never push directly to main, force-push, merge, deploy, alter secrets, or perform destructive production changes without explicit authorization. A draft PR represents review-ready code, **not rollout or migration authorization**. Keep a durable checkpoint on a dedicated non-main coordination branch or approved store. The orchestrator is the sole writer of plan statuses. Aim for roughly three substantial PRs per review batch as a **soft guideline**, never a hard cap, grouping mandate, or reason to stop eligible work.

## Companion and specialist skills

- **i-have-adhd — bundled companion, required for the final handoff style.** The original unmodified skill is shipped in this repository at `../i-have-adhd/SKILL.md`. It may need to be installed/activated separately: Claude Code `/i-have-adhd`; Codex `$i-have-adhd`. When agent skill invocation is available, explicitly load it for the final handoff. Otherwise read its text if available or follow the bundled morning-handoff reference. Do not claim an unavailable skill ran.
- **ponytail — optional complexity review.** Use it for avoidable complexity, excessive abstraction and hidden coupling. Otherwise apply the local-reasoning rules directly. It is **not** a replacement for independent correctness/security/regression review. See https://github.com/DietrichGebert/ponytail.
- **pstack — optional specialist, not an orchestrator.** Use `/architect` **design-only** for consequential design decisions, `/blast-radius` for cross-boundary changes, and `/interrogate` for high-risk independent review when available and justified. Never delegate plan status, task execution ownership, PR creation, or merging to pstack. Fallback to evidence-based manual review when unavailable. See https://github.com/cursor/plugins/tree/main/pstack.
- **simple-english — optional.** If an installed simple-english skill is available, use it to edit commit and PR descriptions. Otherwise write plain, precise prose. See https://github.com/AminBlg/SimpleEnglish.

Do not silently skip required checks when optional skills are absent.

## Mandatory user-facing handoff

For every normal completion, blocked stop, or handled error, follow `references/morning-handoff.md`:

- Put **NEXT ACTION** first, one action achievable in under two minutes.
- State user-visible outcome status, verified behavior with actual PR links, and blocked/incomplete work accurately. Prioritize up to three ready PRs for human attention while linking the full queue.
- Provide no more than five concrete checklist items.
- Give testing evidence, caveats, and an explicit next checkpoint; do not call draft PRs shipped.
- A hard process crash may prevent a final message; checkpointing makes later recovery possible.

## Portability

The Markdown files in this skill's `references/` directory are shipped with the skill when installed through a compatible agent-skills installer. The repository's root copies are also available for people who prefer to paste prompts manually. Keep both copies synchronized when maintaining this project.

Neither Claude Code nor Codex is guaranteed to continue after its CLI process dies. Native Goal mode is a session continuation mechanism, not an unattended scheduler.
