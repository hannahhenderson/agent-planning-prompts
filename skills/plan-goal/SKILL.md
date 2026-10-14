---
name: plan-goal
description: "Plan, execute, or resume engineering issues, tech debt, bugs, and features as approved work with independently verified draft PRs and a concise handoff. Use in Claude Code or Codex when asked to plan a backlog, implement an approved PLAN.md, or recover an interrupted engineering run."
---

# Plan → Goal

Optimize for **valuable, verified outcomes per unit of human attention**, not code volume or PR count. Make code locally understandable; make user-facing changes safe to introduce.

## Route the request

1. Determine whether the user wants **plan**, **execute/resume**, or **review**. Work in their *target repository*, not this skill's source.
2. Read that repository's `AGENTS.md`, `CLAUDE.md`, and stricter project policies.
3. Load the relevant reference; it owns the detailed instructions:

| Stage | Required reference |
| --- | --- |
| Plan | [`references/plan.md`](references/plan.md) |
| Execute or resume | [`references/goal.md`](references/goal.md) |
| Every normal exit | [`references/morning-handoff.md`](references/morning-handoff.md) |

**Planning gate:** Ask about **Minimal / Opportunistic / Refactor-friendly** refactoring appetite at the beginning of a new plan, unless already explicitly answered; record it and obtain plan approval **before** implementing. The planning reference defines the choices and proportional user/data/security risk screen. For legacy approved plans without that preference, ask once before execution.

**Execution boundary:** Use a dedicated branch/worktree for code and a durable non-main checkpoint; the coordinator alone updates plan status. Verify results and remote draft PRs before marking an item `done`. **Never** push to main, force-push, merge, deploy, change credentials/access/secrets, or execute destructive/production operations without explicit authorization. Plan approval is not rollout or migration approval.

## Companion tools

- **`i-have-adhd` (bundled):** activate for the final actionable handoff when available; otherwise follow [morning-handoff.md](references/morning-handoff.md). Do not claim it ran if unavailable.
- **Ponytail (optional):** challenge needless complexity and coupling; it does **not** replace independent correctness/security review.
- **Pstack (optional):** advisory `/architect` for significant design, `/blast-radius` for cross-boundary risk, `/interrogate` for high-risk review. **Never** delegate orchestration, status or PR ownership to Pstack.
- **Simple English (optional):** improve PR and commit wording.

Aim for **about three thoroughly validated PRs per human review batch**, not a limit. Prioritize the first reviews and link the full queue. Do not split/bundle work, stop execution, or mark an item blocked for this number.

Every exit must distinguish verified code from released behavior, state remaining decisions and blockers, and start with a concrete next action. Native `/goal` may continue within a session but cannot resurrect a terminated process.
