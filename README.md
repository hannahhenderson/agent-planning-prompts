# Agent planning prompts

**Next action:** Install the [bundled i-have-adhd skill](skills/i-have-adhd/SKILL.md) in your coding tool, then open the project you want to improve.

Reusable **Plan → Goal → morning checklist** prompts for **Claude Code** and **OpenAI Codex**. The agents do the implementation; you review **draft PRs**. They never merge or deploy on your behalf.

## Start here: what do I do next?

### Once per computer (about 5 minutes if both tools are installed)

- [ ] Install the **bundled** `i-have-adhd` skill for your tool (commands below). The original source is included in `skills/i-have-adhd/`.
- [ ] Check you can open the target repo and create branches and draft PRs.

**Claude Code** — from this repo's root, copy to your personal skills directory:

```sh
mkdir -p ~/.claude/skills/i-have-adhd
cp skills/i-have-adhd/SKILL.md ~/.claude/skills/i-have-adhd/SKILL.md
```

**Codex** — from this repo's root, copy to your personal skills directory:

```sh
mkdir -p ~/.agents/skills/i-have-adhd
cp skills/i-have-adhd/SKILL.md ~/.agents/skills/i-have-adhd/SKILL.md
```

Restart the tool after installing. Activate explicitly using `/i-have-adhd` (Claude Code) or `$i-have-adhd` (Codex). For alternate installation methods and version-specific behavior, see the [author's installation guide](https://github.com/ayghri/i-have-adhd/blob/main/INSTALL.md).

### Every time you run a project (about 2 minutes to launch)

1. - [ ] Open **the project you want changed** in Claude Code or Codex. Do **not** execute the work in this prompts repo.
2. - [ ] **Activate the skill first:** type `/i-have-adhd` in Claude Code, or `$i-have-adhd` in Codex. Activation is explicit; installation alone does not activate it. It stays active for the session.
3. - [ ] **Plan:** open [PLAN_PROMPT.md](PLAN_PROMPT.md), replace `$WORK_KIND`, `$TRACKER` (optional), and `$PLAN_FILE` (usually `PLAN.md`), and paste it in **Plan mode**. Approve the plan; then save it as `$PLAN_FILE` when writing is allowed.
4. - [ ] **Execute:** paste [GOAL_PROMPT.md](GOAL_PROMPT.md) after `/goal` in the **same project** (replace `$PLAN_FILE`). Make sure the model can make the necessary authorized file, Git, and PR changes.
5. - [ ] **Return to a checklist:** the final response must follow [MORNING_HANDOFF.md](MORNING_HANDOFF.md), including a single action you can start in under two minutes.

**Important:** Native `/goal` continues work within its own session. It is *not* a guarantee that a stopped computer or a failed CLI process will restart itself. Use a separate runner only when you actually need unattended restart or scheduling. If the agent is stopped before it can answer, no prompt can guarantee the final checklist; checkpoints make recovery easier.

### When you come back

- [ ] Read only the **NEXT ACTION** at the top of the agent's report.
- [ ] Open the first linked draft PR. Read the summary and test evidence.
- [ ] Review and merge manually only when satisfied; never treat a draft PR as shipped.
- [ ] Handle the top blocker, if there is one, before starting another run.

See [MORNING_HANDOFF.md](MORNING_HANDOFF.md) for the expected output format.

## What's in here?

| File | Use |
| --- | --- |
| [PLAN_PROMPT.md](PLAN_PROMPT.md) | Discover, prioritize, and define verifiable work; no implementation |
| [GOAL_PROMPT.md](GOAL_PROMPT.md) | Execute approved work; create validated draft PRs and checkpoints |
| [MORNING_HANDOFF.md](MORNING_HANDOFF.md) | Standard ADHD-friendly end-of-run checklist |
| [skills/i-have-adhd/SKILL.md](skills/i-have-adhd/SKILL.md) | Complete vendored ADHD output skill | 
| [skills/i-have-adhd/LICENSE](skills/i-have-adhd/LICENSE) | Original MIT license and attribution |

## Private GitHub repository

This repository is already hosted privately at [hannahhenderson/agent-planning-prompts](https://github.com/hannahhenderson/agent-planning-prompts). Clone or copy the files into the target project when you use them. It is a prompt library, not the implementation target.

## Tool-specific notes

- **Claude Code:** `/goal` is session-scoped and can run noninteractively with `claude -p`. Auto/permission mode still controls tool approvals. See [Claude Goal documentation](https://code.claude.com/docs/en/goal).
- **Codex:** `/goal` is a persistent, thread-scoped objective. Confirm you are using a build that supports Goals. See [Codex Goals guide](https://developers.openai.com/cookbook/examples/codex/using_goals_in_codex).
- **Planning:** If Plan mode is read-only, the agent should display a draft for your approval. Save the approved plan once in write-enabled mode; never assume Plan mode wrote a file.
- **Skills:** This repo includes an unmodified copy of [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd/blob/main/skills/i-have-adhd/SKILL.md), © 2026 Ayoub Ghriss, under the [MIT license](skills/i-have-adhd/LICENSE). It is not updated automatically from upstream; the skill must be installed or made discoverable in each tool and activated explicitly.

## Defaults and boundaries

- **Default:** one implementation task at a time; optional independent review sub-agents.
- **Checkpoint:** stable IDs and `Status: todo | in progress | done | blocked` lines in the plan; the coordinating agent alone changes them.
- **Done:** tests and validations recorded, branch pushed, draft PR verified. A blocked task is **not** done.
- **Never:** push to main, force-push, merge, deploy, change secrets, or modify production data without explicit human authorization.
