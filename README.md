# Plan → Goal

**Small, safe, verified engineering changes with low human review overhead.**

A Claude Code + Codex skill that turns issues or feature goals into an approved plan, then into independently verified **draft PRs** and a short handoff. Install once; run it inside the project you want to change.

## Philosophy

**Make change safe by making reasoning local. Make delegation to the robots useful by making results easy to trust.**

Two priorities sometimes compete:

1. **Developer experience.**

   Minimize the context needed to understand, test, and modify code. Prefer explicit dependencies, local state, isolated side effects, and the smallest *complete* change. Abstractions should reduce overall reasoning cost, not just relocate complexity. 

   Refactoring has a cost, so the agent asks at the start of planning:

    - **Minimal**: smallest safe complete change; propose optional refactors separately (suggested for shared/work code).
    - **Opportunistic**: contained refactors with clear payoff (suggested for personal projects).
    - **Refactor-friendly**: broader improvements when benefit exceeds implementation, test, review, and coordination costs.

   These are suggestions; **the user chooses**, and the plan records the decision.

2. **Product and user experience.**

   Solve the user's problem, including the experience of rollout, error states, partial availability, and recovery. 
   
   Plan safe data transitions and mixed-version compatibility where needed. Design security and privacy in from the start: protect trust boundaries, consider accidental and deliberate misuse, and enforce sensible server-side limits on costly or shared-resource operations. Start with limits that can safely grow; make them visible and actionable for legitimate users.

**When these two priorities conflict.**

The cleanest implementation can produce a poor experience; a polished experience can impose disproportionate maintenance cost. Make the trade-off and its owner explicit. Prefer the smallest complete solution that delivers the user outcome safely and stays reasonable to maintain. Reliability, security, privacy, and data integrity are constraints, not optional shortcuts.

**Agentic development.**

Challenge whether new work is needed. Prove observed behavior rather than trusting agent assertions. Delegate routine reversible decisions; seek approval for material product, architecture, security, data, or rollout decisions. Aim for **roughly three highly validated PRs per review batch**, as a guideline, **never a cap** or a reason to bundle unrelated work or stop progress. Preserve recoverable checkpoints and prioritize the human's next action.

**Every instruction must earn its keep:**

Scale analysis to risk; do not generate checklists, reviews, or artifacts that a change does not warrant.

## Install

Requires Git, Node/npm, GitHub authentication, and Claude Code or Codex. This repository is private; installation requires repository access.

```sh
npx skills add hannahhenderson/agent-planning-prompts --skill plan-goal --skill i-have-adhd -g
```

Restart your agent and confirm both skills are available. Omit `-g` for project-local installation.

## Use

1. Open the **target project**, not this skill's repository.
2. **Plan:** ask `plan-goal` to plan issues or a feature into `PLAN.md`. Answer its one-time refactoring question and approve the plan before implementation.
3. **Execute:** invoke native `/goal` with the approved `PLAN.md` (or use a normal agent session if unavailable).
4. **Review:** follow the short handoff; inspect the highest-priority draft PRs and any human-owned rollout or migration steps.

Example plan request:

```text
Use plan-goal to plan the open GitHub bugs in this repo into PLAN.md. Do not implement yet.
```

Example execution request:

```text
/goal Use plan-goal to execute approved PLAN.md until each eligible item has a verified draft PR or a documented blocker. End with an i-have-adhd handoff.
```

Claude Code can activate `/plan-goal` and `/i-have-adhd`; Codex can activate `$plan-goal` and `$i-have-adhd`. Plan mode may be read-only: save the **approved** plan in a writable mode. Native Goal mode does not restart a killed CLI process.

## Source and optional tools

- [`skills/plan-goal/SKILL.md`](skills/plan-goal/SKILL.md): installable router; [planning](skills/plan-goal/references/plan.md), [execution](skills/plan-goal/references/goal.md), and [handoff](skills/plan-goal/references/morning-handoff.md) instructions.
- [`skills/i-have-adhd`](skills/i-have-adhd/SKILL.md): bundled companion for an actionable handoff.
- [`PLAN_PROMPT.md`](PLAN_PROMPT.md), [`GOAL_PROMPT.md`](GOAL_PROMPT.md), [`MORNING_HANDOFF.md`](MORNING_HANDOFF.md): paste-friendly copies, checked for synchronization in CI.
- [Evaluation scenarios](EVALUATION_SCENARIOS.md): representative cases to run before treating the workflow as proven.

Optional, separately installed specialists: [Ponytail](https://github.com/DietrichGebert/ponytail) for simplicity/locality, [Pstack](https://github.com/cursor/plugins/tree/main/pstack) for targeted risk/architecture review (not orchestration), and [Simple English](https://github.com/AminBlg/SimpleEnglish) for clear PR wording. None substitutes for independent correctness/security review.

## Limits and attribution

The agent may open **draft PRs on task branches**, not push to main, merge, deploy, change access/secrets, or execute production rollouts or data migrations. Plan approval does **not** authorize those operations. `Status: done` means a verified draft PR, **not shipped**. Checkpoints enable recovery, but an agent cannot guarantee continuation after its process dies.

The bundled `i-have-adhd` skill is an unmodified copy of [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd), copyright © 2026 Ayoub Ghriss, licensed [MIT](skills/i-have-adhd/LICENSE); updates are not automatic. Keep root prompts synchronized with their `skills/plan-goal/references/` copies and preserve the parseable `Status: todo | in progress | done | blocked` values.
