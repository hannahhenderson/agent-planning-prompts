# Plan → Goal

A reusable **Claude Code + Codex agent skill**: plan engineering work, execute an approved backlog as validated **draft PRs**, and finish with an ADHD-friendly next-action checklist.

**No scripts to run every night. No prompts to copy every run.** Install the skills once, then invoke the workflow from the project you want to change.

> **Access:** This GitHub repository is currently private. People you share it with need repository access to install from it. You can invite collaborators without making it public.

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
| **[Ponytail](https://github.com/DietrichGebert/ponytail)** | Review code for unnecessary complexity | No, third-party integration | Optional; use a direct review if absent |
| **[Simple English](https://github.com/AminBlg/SimpleEnglish)** | Improve PR and commit wording | No, third-party integration | Optional; use clear prose if absent |

The Ponytail and Simple English links are **suggested public implementations**, not a claim that they are identical to an individual's existing installations. Install them separately if desired, following their own documentation. Optional dependencies must never block otherwise safe, validated work.

## Every time you want to run it

1. - [ ] Open **the target project's directory** in Claude Code or Codex.
2. - [ ] **Plan:** invoke the `plan-goal` skill in Plan mode. Tell it what kind of issues to plan and where they live; default the plan to `PLAN.md`. Review the plan before authorizing implementation.
3. - [ ] **Execute:** after the approved plan is saved, use native `/goal` to run the plan-goal workflow against `PLAN.md` until each item has a verified draft PR or a recorded blocker.
4. - [ ] **Come back:** start with the agent's **NEXT ACTION**, then review the linked draft PRs and unresolved blockers. No more than five checklist items should be visible.

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
- The agent checkpoints work and reconciles status against Git and actual PRs on resumption.
- Only the coordinating agent edits the plan file. Blocked work is explicitly distinguished from done.
- Each run should end with one small next action, real test evidence, and no more than five review steps.
- A crash or hard kill can prevent the final handoff; use persisted state to recover.
- A private repository is shareable **only with people who have access**. Do not assume a link alone grants installation rights.

For native `/goal` behavior, see [Claude Code's documentation](https://code.claude.com/docs/en/goal) and [Codex's guide](https://developers.openai.com/cookbook/examples/codex/using_goals_in_codex).

## Maintenance and attribution

The [i-have-adhd skill](skills/i-have-adhd/SKILL.md) is an unmodified copy of [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd), copyright © 2026 Ayoub Ghriss, distributed under the [MIT license](skills/i-have-adhd/LICENSE). Updates to upstream are **not** pulled automatically.

The prompt copies at the repo root and their counterparts under `skills/plan-goal/references/` must be updated together. To contribute, maintain backwards-compatible `Status: todo | in progress | done | blocked` lines and keep the prompts generic—never hardcode personal repos, secrets, or tokens.
