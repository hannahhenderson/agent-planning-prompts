# Morning handoff — template

> The agent must use the bundled [`i-have-adhd` skill](../../i-have-adhd/SKILL.md) **when it has been explicitly activated**. This file is a concrete completion checklist; install or expose the bundled skill in the target project and activate it explicitly.
>
> Show this handoff after **every run**, including partial progress, blockers, and errors. If the process is killed before it can respond, a prompt cannot guarantee a final response; use checkpoint data to reconstruct the handoff on restart.

**NEXT ACTION (under 2 minutes):** Open [the first draft PR](#) and read its summary.

**Outcome:** `[user-visible goal]` — `[verified / partially verified / blocked]` (replace with evidence, not self-report).

**Progress:** `2 verified PRs ready · 1 blocked · 1 not started` (replace with real counts; never invent them).

## Your morning checklist

1. - [ ] **Review PR #123:** brief purpose, link, and key validation evidence. Estimated review time: ~10 minutes (estimate only if justified).
2. - [ ] **Review PR #124:** brief purpose, link, and key validation evidence.
3. - [ ] **Resolve one blocker:** issue link, plain-language reason, and one precise decision needed.
4. - [ ] **Check remaining queue:** link the durable checkpoint, the full PR index, and what remains.

## Evidence and exceptions

- **Verified:** real observed behavior, exact test commands/results, integration proof when needed, and PR/branch references.
- **Review order:** prioritize up to three high-value ready PRs as a guideline; link the entire queue. Call out significant coupling/refactoring decisions.
- **Unverified:** skipped tests, environment restrictions, known defects, and residual risks.
- **Stopped because:** complete, no independent work remains, permission required, deadline, usage limit, or other actual reason.

**NEXT:** Open [the most important draft PR](#). (One short action; if already present at the top, you may omit this last line.)

---

### Rules for agents

- The **first line** must be something the reader can do immediately—not a preamble.
- One action per checkbox; no more than five visible actions. Aim for three priority PR reviews without hiding, delaying, or blocking additional completed work; link a complete index.
- Make completed changes concrete, and mark uncertain claims honestly.
- No generic closing remarks. If a human decision is required, state one exact question.
- No follow-up time promises; all actions must reflect work already done or an explicitly running external automation.
