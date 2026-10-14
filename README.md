# Plan → Goal

A reusable **Claude Code + Codex agent skill** for trustworthy delegation: challenge work, plan user-visible outcomes, make safe local changes, and produce exceptionally well-validated **draft PRs** with a low-friction handoff.

**No scripts to run every night. No prompts to copy every run.** Install the skills once, then invoke the workflow from the project you want to change.

> **Access:** This GitHub repository is currently private. People you share it with need repository access to install from it. You can invite collaborators without making it public.

## Engineering and review defaults

**Optimize for valuable outcomes per unit of human attention, not issue count or PR count.** Prefer safe, local changes: explicit dependencies, isolated side effects, limited hidden state, and abstractions only when they reduce total reasoning overhead. Challenge whether work needs to exist before implementing it.

**The first planning question is refactoring appetite:** Minimal (smallest safe complete change, optional refactors separately), Opportunistic (contained, demonstrated improvements), or Refactor-friendly (broader improvements whose total value outweighs implementation, testing, review, and coordination cost). Recommend Minimal for work/shared projects and Opportunistic for personal projects, **but ask rather than assuming**. Record the answer in the approved plan.

**Aim for roughly three exceptionally well-validated PRs per human review batch.** This is a guideline, **not a hard cap**, not a reason to combine unrelated changes, and not a reason to halt otherwise eligible work. Plan and verify complete user-visible outcomes, including dependencies across PRs.

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
- Each run should end with one small next action, real test evidence, and no more than five review steps.
- A crash or hard kill can prevent the final handoff; use persisted state to recover.
- A private repository is shareable **only with people who have access**. Do not assume a link alone grants installation rights.

For native `/goal` behavior, see [Claude Code's documentation](https://code.claude.com/docs/en/goal) and [Codex's guide](https://developers.openai.com/cookbook/examples/codex/using_goals_in_codex).

## Workflow evaluation

Use [EVALUATION_SCENARIOS.md](EVALUATION_SCENARIOS.md) to test refactoring decisions, avoided work, locality, validation, review cost and crash recovery against representative cases. The `check-prompt-sync` workflow keeps root paste prompts identical to the installed skill's references.

## Maintenance and attribution

The [i-have-adhd skill](skills/i-have-adhd/SKILL.md) is an unmodified copy of [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd), copyright © 2026 Ayoub Ghriss, distributed under the [MIT license](skills/i-have-adhd/LICENSE). Updates to upstream are **not** pulled automatically.

The prompt copies at the repo root and their counterparts under `skills/plan-goal/references/` must be updated together. To contribute, maintain backwards-compatible `Status: todo | in progress | done | blocked` lines and keep the prompts generic—never hardcode personal repos, secrets, or tokens.
