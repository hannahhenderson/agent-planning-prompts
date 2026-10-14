# Plan → Goal

A reusable **Claude Code + Codex agent skill** for trustworthy delegation: challenge work, plan user-visible outcomes, make safe local changes, and produce exceptionally well-validated **draft PRs** with a low-friction handoff.

**No scripts to run every night. No prompts to copy every run.** Install the skills once, then invoke the workflow from the project you want to change.

> **Access:** This GitHub repository is currently private. People you share it with need repository access to install from it. You can invite collaborators without making it public.

## Philosophy

**Make change safe by making reasoning local. Make delegation useful by making its results easy to trust.**

Writing code is rarely the hard part of software development. Understanding what should change, what must stay the same, and whether the result actually works is harder. Coding agents can produce changes quickly, but speed is only useful when the output is safe, maintainable, and inexpensive for a human to evaluate.

This workflow balances two distinct philosophies: **developer experience** and **product and user experience**. We started by optimizing how safely engineers and agents can reason about code. That is necessary, but not sufficient: the result must also serve users and be safe to introduce into the world. Autonomous execution connects both through verifiable evidence and bounded human oversight.

### Developer experience

**Local reasoning over global knowledge.** Prefer behavior that can be understood, tested, and modified without reconstructing unrelated parts of the system. Make dependencies explicit, keep state and transitions local, and isolate side effects at clear boundaries. Use pure, testable functions where practical, without imposing a paradigm on codebases that do not use it.

**The smallest *complete* change, not necessarily the smallest diff.** Minimize blast radius and unnecessary work, but include the callers, tests, error handling, and integration needed to finish the job. A few lines that modify shared global state may be riskier than a longer change with explicit boundaries.

**Abstractions must earn their keep.** Introduce an abstraction when it *reduces the total context needed to reason about the system*. Moving complexity behind more layers or adding speculative flexibility is not necessarily an improvement. Prefer an existing helper or a direct implementation when either is clearer.

**Refactoring is an investment, not a virtue.** Improving structure can make future changes cheaper, but broad refactors also cost implementation time, testing, review, and coordination. The right tradeoff depends on whether this is a personal project or shared production code, so the agent asks about refactoring appetite **at the beginning of every planning run**:

- **Minimal:** make the smallest safe complete change; propose optional refactors separately. Recommended for shared/work code.
- **Opportunistic:** include contained refactors when they demonstrably improve locality or maintainability. Recommended for personal projects.
- **Refactor-friendly:** consider broader improvements when their total benefit outweighs their full cost.

These are recommendations, not automatic selections. The user decides, and the approved plan records the answer.

### Product and user experience

**Solve the user's problem, not just the ticket.** Start with the outcome people need and the experience they should have. Consider the whole journey, not only the implemented feature or happy path. Avoid building functionality that creates more confusion, work, or risk than it removes.



**The rollout is part of the user experience.** A feature is not finished merely because the new code works. Consider how people discover and experience it, including old and new clients, partial availability, loading and error states, accessibility, communication, and the ability to recover when things fail. For consequential changes, plan progressive exposure, observability, ownership, stop conditions, and a feasible way to disable or mitigate the change. Feature flags and phased rollouts are tools, not rituals; use them when they make the transition safer.

**Data migrations are transitions, not single operations.** Plan how old and new application versions coexist with old and new data. When appropriate, separate schema expansion, backfill, and removal of legacy fields. Consider idempotency, batches, locking and performance impact, data integrity checks, monitoring, and what to do if the migration stops halfway. A destructive migration or data rewrite may not be reversible; specify a realistic recovery or forward-fix strategy rather than promising a rollback that cannot work.

**Security is a design input, not a final gate.** Start from trust boundaries, data sensitivity, identity, authorization, and credible misuse. Validate untrusted inputs and outputs at the right boundaries, enforce least privilege and tenant isolation where applicable, and avoid exposing secrets or sensitive data in logs, errors, or retained artifacts. Higher-risk changes should include a lightweight threat model and focused abuse/security tests. Security review strengthens these decisions; it cannot replace making them during planning.

**Risk determines ceremony.** Every plan considers customer impact, persistent data, and security. When a dimension is not affected, say so briefly. When it is affected, plan the transition and its proof. A small internal fix does not need a migration playbook; a customer-data change may require careful sequencing, human approval, and a separate rollout plan. A verified draft PR is **ready for review, not deployed or released**.

### When the philosophies conflict

These goals are complementary, but they are not always aligned. A cohesive user experience may require more code, compatibility work, or coordination than an engineer would prefer. A satisfying refactor may improve the developer experience while delaying meaningful user value. A smaller implementation may be easier to review but leave users with awkward transitions or unreliable behavior.

**Do not resolve these tensions by always choosing the shortest diff, the cleanest architecture, or the most ambitious product experience.** Identify the alternatives, who benefits, who pays the cost, and what risks remain. Prefer the smallest *complete* solution that delivers the intended user outcome safely and remains reasonable to maintain. For material trade-offs in user behavior, scope, cost, security or architecture, surface the decision for human approval.

Reliability, security, privacy and data integrity are constraints on both philosophies, not optional trade-offs for speed or convenience.

### How we think about agentic development

**Question the work before implementing it.** A tracker issue describes a request, not necessarily the best solution. Sometimes the right result is to reuse existing behavior, narrow the feature, or write no code.

**Plan outcomes, not activity.** Define the user-visible behavior, the experience of introducing it, and the evidence that would prove it works. Divide that outcome into cohesive, independently reviewable changes instead of maximizing tasks or PRs.

**Autonomy needs boundaries.** Let agents make routine, reversible implementation decisions, but require explicit approval for consequential product, security, architectural, operational, data, or scope decisions. An agent should not quietly choose an expensive refactor on someone else's behalf.

**Evidence over confidence.** Prefer reproducible tests and observed behavior to persuasive summaries, passing compilation, or agent self-assessment. Scale verification to risk; review correctness, security, blast radius, and needless complexity as distinct concerns.

**Optimize the human review cost.** Aim for roughly **three exceptionally well-validated PRs per review batch**, not as a hard cap. More PRs are appropriate when they improve isolation or reviewability. Never bundle unrelated changes, split cohesive work, or stop useful execution to satisfy the guideline.

**Leave a recoverable trail.** Persist progress, reconcile claims against actual Git and PR state, and return a short handoff with the next action, validation evidence, and unresolved decisions. A human should not need to reconstruct an agent's entire session.

The goal is **trustworthy progress, not autonomous activity**. The best outcome may be one small PR, several well-separated PRs, or a justified decision not to change the code at all.

## Getting started — once per computer

- [ ] Make sure Claude Code or Codex, Git, and Node/npm are available. Configure GitHub authentication so your agent can create branches and draft PRs in the *target* project.
- [ ] Install the two bundled skills globally (the private repository requires GitHub access):

```sh
npx skills add hannahhenderson/agent-planning-prompts --skill plan-goal --skill i-have-adhd -g
```

- [ ] Restart your coding agent, then check that **plan-goal** and **i-have-adhd** are discoverable. If you want to install into just one project, omit `-g`.

The installer supports Claude Code and Codex and offers agent selection if needed. You can also [browse the skill source](skills/plan-goal/SKILL.md), or [install the skills from a local clone](https://www.npmjs.com/package/skills) if private Git authentication is unavailable.

### Companion skills

The workflow uses three distinct skills. **They are not three copies of the same functionality.**

| Skill | Role | Included here? | Requirement |
| --- | --- | --- | --- |
| **[plan-goal](skills/plan-goal/SKILL.md)** | Plan, execute, verify and checkpoint engineering work | **Yes** — primary skill | Required |
| **[i-have-adhd](skills/i-have-adhd/SKILL.md)** | Shape the final report into an actionable checklist | **Yes** — vendored, with [MIT attribution](skills/i-have-adhd/LICENSE) | Required handoff style |
| **[Ponytail](https://github.com/DietrichGebert/ponytail)** | Optional complexity and local-reasoning review | No, third-party integration | Does not replace correctness/security review |
| **[Pstack](https://github.com/cursor/plugins/tree/main/pstack)** | Optional targeted architecture, blast-radius, and adversarial reviews | No, third-party integration | Specialist only; never a second orchestrator |
| **[Simple English](https://github.com/AminBlg/SimpleEnglish)** | Improve PR and commit wording | No, third-party integration | Optional; use clear prose if absent |

The Ponytail, Pstack, and Simple English links are **suggested public implementations**, not a claim that they are identical to an individual's existing installations. Install them separately if desired, following their own documentation. Optional dependencies must never block otherwise safe, validated work.

## Every time you want to run it

1. - [ ] Open **the target project's directory** in Claude Code or Codex.
2. - [ ] **Plan:** invoke the `plan-goal` skill in Plan mode, answer the up-front refactoring question, and review its proposed outcomes, exclusions and verification before authorizing implementation; default the plan to `PLAN.md`.
3. - [ ] **Execute:** after the approved plan is saved, use native `/goal` to run the plan-goal workflow against `PLAN.md` until each item has a verified draft PR or a recorded blocker.
4. - [ ] **Come back:** start with **NEXT ACTION**, review the three highest-priority ready PRs first, and use the full index for remaining draft PRs and blockers. No more than five checklist actions should be visible.

**Example instructions to type in your coding agent:**

**Plan:**
```text
Use the plan-goal skill to plan the open GitHub bugs in this repo into PLAN.md. Do not implement yet.
```

**Execute** (in tools that support `/goal`):
```text
/goal Use the plan-goal skill to implement approved PLAN.md. Continue until every eligible item has a validated draft PR or documented blocker. End with an i-have-adhd checklist.
```

**Skill activation:** In Claude Code you can use `/plan-goal` and `/i-have-adhd`; in Codex, `$plan-goal` and `$i-have-adhd`. Activate `i-have-adhd` early in the session if you want ADHD-style responses throughout, not only at the final handoff. The workflow also includes [a fallback handoff template](skills/plan-goal/references/morning-handoff.md) if the companion skill cannot run.

**Important:** Plan mode can be read-only. Save the approved plan after switching to a mode that permits edits. Goal mode continues within an active session; it does **not** automatically restart a dead CLI process.

## When you come back — your checklist

- [ ] Open the **first** linked draft PR.
- [ ] Read what changed and the validation results.
- [ ] Review and merge it manually only if satisfied.
- [ ] Resolve the highest-priority blocker, if any.
- [ ] Resume remaining planned work when ready.

## Repository map

| Location | Purpose |
| --- | --- |
| [skills/plan-goal/SKILL.md](skills/plan-goal/SKILL.md) | **Installable entrypoint**; routes planning, execution, recovery, and handoff |
| [skills/plan-goal/references/](skills/plan-goal/references/) | Self-contained workflow instructions shipped with the skill |
| [skills/i-have-adhd/SKILL.md](skills/i-have-adhd/SKILL.md) | Vendored handoff-style skill |
| [PLAN_PROMPT.md](PLAN_PROMPT.md) | Paste-friendly planning prompt (manual alternative) |
| [GOAL_PROMPT.md](GOAL_PROMPT.md) | Paste-friendly execution prompt (manual alternative) |
| [MORNING_HANDOFF.md](MORNING_HANDOFF.md) | Paste-friendly morning-handoff template (manual alternative) |

## Design and limitations

- Agent changes are restricted to dedicated branches/worktrees and **draft PRs**. Never push to main, force-push, merge, or deploy.
- The agent checkpoints on a durable non-main coordination branch or approved store and reconciles state against actual Git refs, tests, and PRs on resumption.
- Only the coordinating agent edits the plan file. Blocked work is explicitly distinguished from done.
- Review-ready PRs are not production releases. Rollout, migration execution, and destructive/irreversible changes require their own explicit approval and ownership.
- Each run should end with one small next action, real test evidence, and no more than five review steps.
- A crash or hard kill can prevent the final handoff; use persisted state to recover.
- A private repository is shareable **only with people who have access**. Do not assume a link alone grants installation rights.

For native `/goal` behavior, see [Claude Code's documentation](https://code.claude.com/docs/en/goal) and [Codex's guide](https://developers.openai.com/cookbook/examples/codex/using_goals_in_codex).

## Workflow evaluation

Use [EVALUATION_SCENARIOS.md](EVALUATION_SCENARIOS.md) to test refactoring decisions, avoided work, locality, validation, review cost and crash recovery against representative cases. The `check-prompt-sync` workflow keeps root paste prompts identical to the installed skill's references.

## Maintenance and attribution

The [i-have-adhd skill](skills/i-have-adhd/SKILL.md) is an unmodified copy of [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd), copyright © 2026 Ayoub Ghriss, distributed under the [MIT license](skills/i-have-adhd/LICENSE). Updates to upstream are **not** pulled automatically.

The prompt copies at the repo root and their counterparts under `skills/plan-goal/references/` must be updated together. To contribute, maintain backwards-compatible `Status: todo | in progress | done | blocked` lines and keep the prompts generic—never hardcode personal repos, secrets, or tokens.
