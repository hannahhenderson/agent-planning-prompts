---
name: plan-goal
description: "Reusable Plan → Goal engineering workflow for Claude Code and Codex. Turn repo issues, tech debt, bugs, or features into an approved plan, implement them as independently validated draft PRs, and produce a short actionable morning handoff. Use when asked to plan a backlog, run an approved plan, or resume an autonomous engineering run."
---

# Plan → Goal

Help someone plan and execute repository work through **reviewable draft PRs**, with a clear handoff that says exactly what to do next.

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

Use Plan mode if supported. Gather `WORK_KIND` (bugs, features, tech debt), `TRACKER` (Linear, GitHub Issues, file, or none), and `PLAN_FILE` (default `PLAN.md`) from the user's request. Do not ask for values you can infer safely.

Inspect the code, tracker, tests, dependencies, and existing PRs. Apply `references/plan.md` to produce verifiable, sequenced work items with exact `Status: todo` lines. Present the plan for approval; do not implement yet. If Plan mode is read-only, persist it only after approval in a mode that allows writing.

## Execute or resume

Read `references/goal.md` and the approved plan. The completion condition is **every eligible item backed by a verified draft PR or documented as blocked**, with no unaccounted-for `todo` or `in progress` items in a report claiming complete. Confirm PRs and validation against actual remote state, not status text alone.

If native `/goal` is supported, set this as a concise completion condition and keep detailed execution instructions in the reference. If unavailable, follow the instructions in a normal execution session without promising automatic continuation.

Never push directly to main, force-push, merge, deploy, alter secrets, or perform destructive production changes without explicit authorization. Keep a recoverable checkpoint. The orchestrator is the sole writer of plan statuses.

## Three complementary skills

- **i-have-adhd — bundled companion, required for the final handoff style.** The original unmodified skill is shipped in this repository at `../i-have-adhd/SKILL.md`. It may need to be installed/activated separately: Claude Code `/i-have-adhd`; Codex `$i-have-adhd`. When agent skill invocation is available, explicitly load it for the final handoff. Otherwise read its text if available or follow the bundled morning-handoff reference. Do not claim an unavailable skill ran.
- **ponytail — optional.** If an installed ponytail review skill is available, invoke it for complexity-focused review in addition to independent correctness/security review. Otherwise do that review directly. See https://github.com/DietrichGebert/ponytail.
- **simple-english — optional.** If an installed simple-english skill is available, use it to edit commit and PR descriptions. Otherwise write plain, precise prose. See https://github.com/AminBlg/SimpleEnglish.

Do not silently skip required checks when optional skills are absent.

## Mandatory user-facing handoff

For every normal completion, blocked stop, or handled error, follow `references/morning-handoff.md`:

- Put **NEXT ACTION** first, one action achievable in under two minutes.
- State verified progress, with actual PR links, and call out blocked/incomplete work accurately.
- Provide no more than five concrete checklist items.
- Give testing evidence, caveats, and an explicit next checkpoint; do not call draft PRs shipped.
- A hard process crash may prevent a final message; checkpointing makes later recovery possible.

## Portability

The Markdown files in this skill's `references/` directory are shipped with the skill when installed through a compatible agent-skills installer. The repository's root copies are also available for people who prefer to paste prompts manually. Keep both copies synchronized when maintaining this project.

Neither Claude Code nor Codex is guaranteed to continue after its CLI process dies. Native Goal mode is a session continuation mechanism, not an unattended scheduler.
