# Agent planning prompts

**Next action:** Install the [i-have-adhd skill](https://github.com/ayghri/i-have-adhd/blob/main/INSTALL.md) in the coding tool you use. Then open the repository you want to improve.

Reusable **Plan → Goal → morning checklist** prompts for **Claude Code** and **OpenAI Codex**. The agents do the implementation; you review **draft PRs**. They never merge or deploy on your behalf.

## Start here: what do I do next?

### Once per computer (about 5 minutes if both tools are installed)

- [ ] Install the upstream `i-have-adhd` skill for your tool (commands below). This is a separate skill, **not bundled into this repo**.
- [ ] Check you can open the target repo and create branches and draft PRs.

**Claude Code** (from the [upstream install guide](https://github.com/ayghri/i-have-adhd/blob/main/INSTALL.md)):

```sh
claude plugin marketplace add ayghri/i-have-adhd
claude plugin install i-have-adhd@i-have-adhd
```

**Codex** (from the same guide):

```sh
codex plugin marketplace add ayghri/i-have-adhd --ref main
codex plugin add i-have-adhd@i-have-adhd
```

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
| `publish.sh` | Publish this folder as a **private** GitHub repository from your computer |

## Put this bundle in your private GitHub

If this folder is not already hosted, install [GitHub CLI](https://cli.github.com/) and run from the extracted folder:

```sh
./publish.sh
```

This creates a **private** repo named `agent-planning-prompts` under your authenticated GitHub account, and verifies its visibility. It refuses to overwrite an existing remote repo. You can provide a different name: `./publish.sh my-prompt-library`.

Prefer the website? [Create a new repository](https://github.com/new), select **Private**, then upload these files. Check the visibility again after creation.

## Tool-specific notes

- **Claude Code:** `/goal` is session-scoped and can run noninteractively with `claude -p`. Auto/permission mode still controls tool approvals. See [Claude Goal documentation](https://code.claude.com/docs/en/goal).
- **Codex:** `/goal` is a persistent, thread-scoped objective. Confirm you are using a build that supports Goals. See [Codex Goals guide](https://developers.openai.com/cookbook/examples/codex/using_goals_in_codex).
- **Planning:** If Plan mode is read-only, the agent should display a draft for your approval. Save the approved plan once in write-enabled mode; never assume Plan mode wrote a file.
- **Skills:** `i-have-adhd` has different explicit invocation syntax in Claude Code and Codex. The source is [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd/blob/main/skills/i-have-adhd/SKILL.md), licensed MIT by its author. This repo **links to** it rather than redistributing it.

## Defaults and boundaries

- **Default:** one implementation task at a time; optional independent review sub-agents.
- **Checkpoint:** stable IDs and `Status: todo | in progress | done | blocked` lines in the plan; the coordinating agent alone changes them.
- **Done:** tests and validations recorded, branch pushed, draft PR verified. A blocked task is **not** done.
- **Never:** push to main, force-push, merge, deploy, change secrets, or modify production data without explicit human authorization.
