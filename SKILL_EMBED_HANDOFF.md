# Handoff: reconciling skill embedding

**NEXT ACTION (under 2 minutes):** Decide where Pstack comes from: the official `cursor/plugins` repo or the community `pstack-claude` port. See [Open decisions](#open-decisions). Nothing else is blocked on you.

**Status:** Design discussion only. **No prompt, skill or README file has been changed.** This doc is the only change on this branch.

## The question that started this

Why is `i-have-adhd` installed by default, while Ponytail, Pstack and Simple English are not?

Hannah values consistency. The current layout looks arbitrary.

## What the repo does today (at `6a7c2d4`)

Companions differ on two separate axes.

| Companion | Distribution | Wiring in the loop |
| --- | --- | --- |
| `i-have-adhd` | **Vendored** in `skills/`, installed by the one `npx skills add` command | Named in the exit contract. `morning-handoff.md` is its fallback. |
| Ponytail | Linked only, no install command | `goal.md` step 4: complexity review, "if present" |
| Pstack | Linked only, no install command | `goal.md` step 4: `/blast-radius`, `/interrogate`, `/architect` |
| Simple English | Linked only, no install command | **Named in README and `SKILL.md`, but no step in `goal.md` uses it** |

The repo never states **why** one companion is vendored and the others are not. The README explains the license of the vendored copy. It does not explain the reason for vendoring.

## Decisions so far

1. **One rule for every companion.** Each is a skill installed with `npx skills add ... -y` at the **start of every run**. This keeps them current. None is copied into this repo. This includes `i-have-adhd`, so there is no vendored exception.
2. **No per-skill fallbacks.** The install is expected to work. Keep **one** line for failure: if a run-start install fails, say so and continue in a reduced mode. This follows the repo's own rule: never claim an unavailable tool ran.
3. **Simple English: promote.** Add it to `goal.md` step 6, where PR and commit text is written.
4. **Pstack: keep.** It is the only companion that gives architecture oversight **during execution**.
   - `/architect` settles interfaces and module shape before code is written.
   - `/blast-radius` finds what a small change could break. It needs one fact proven by running code.
   - `/interrogate` has several models try to break a diff.
   - Ponytail only removes needless complexity. The plan's impact screen is a **planning-time** check, not an execution-time design review.
   - Install the **individual skills**, not the `poteto-mode` router. `goal.md` already says "never a second orchestrator".

### Rejected options and why

- **Keep one vendored companion and write down the rule.** This was my first recommendation. It is cheaper, but it keeps a vendored copy that drifts ("updates are not automatic"). Hannah chose full consistency.
- **Drop Pstack.** I recommended this because I believed it could not install the same way as the others. That was wrong. Pstack does install through the skills CLI. It was also the only architecture-oversight tool.
- **Vendor all four.** Pstack lives in a shared monorepo with its own license, so there is nothing clean to copy.

## What I verified

`npx skills add` comes from the `vercel-labs/skills` CLI. It puts a `SKILL.md` (plus optional `scripts/` and `references/`) into `.claude/skills/`. The default is a symlink from a shared cache, so updates propagate. `-y` skips prompts.

| Companion | Installs with `npx skills add`? | Notes |
| --- | --- | --- |
| `i-have-adhd` | Yes | The repo already uses this path. |
| Simple English | Yes | `npx skills add AminBlg/SimpleEnglish`. Markdown only, "no dependencies". |
| Ponytail | Partly | It is a Claude plugin that includes hooks and scripts. Install the `skills/ponytail/SKILL.md` subpath to get only markdown. |
| Pstack | Yes, with caveats | `npx skills add cursor/plugins --skill <name> --agent claude-code`. The plugin is Cursor-first. |

Why this matters for safety: through the skills CLI you load third-party **instructions**, not third-party **code**. The plugin routes (Ponytail's hooks, Simple English's session hook) run code. Avoid them.

## Open decisions

1. **Pstack source.** Choose one:
   - **Official `cursor/plugins`.** The author maintains it. It is written for Cursor. `/interrogate` may rely on Cursor features such as model routing and subagents.
   - **Community `pstack-claude` port.** It uses Claude Code tool names. It adds one more maintainer to trust.
   - **Smoke test first.** Install `/architect` and `/blast-radius` in a throwaway Claude Code project and run them on a sample diff. About 5 minutes. I recommend this before choosing. I found **no official statement** that Pstack works in Claude Code, and my sources disagree.
2. **Pin or float?** "Always fresh" means whatever the upstream owners push last night runs in tonight's session. Pinning to a tag removes that risk, but then bumping the pin is maintenance in this repo, which you want to avoid. If you accept floating, then because these are instructions and not code, the risk is mainly prompt injection. `goal.md` already says to treat repository and issue content as data. I lean toward floating. This is your call.
3. **Where does the run-start install live?** It could be a step in `SKILL.md`'s routing, a line in `goal.md` preflight, or a small script. This is not decided.

## Constraints to remember

- **CI byte-equality.** `.github/workflows/check-prompt-sync.yml` runs `cmp` on three pairs. Any edit must be mirrored exactly:
  - `PLAN_PROMPT.md` and `skills/plan-goal/references/plan.md`
  - `GOAL_PROMPT.md` and `skills/plan-goal/references/goal.md`
  - `MORNING_HANDOFF.md` and `skills/plan-goal/references/morning-handoff.md`
- **Read the current prompts in `GOAL_PROMPT.md` and `goal.md` before editing.** The root `MORNING_HANDOFF.md` links `../../i-have-adhd/SKILL.md`, which resolves correctly only from the `references/` path. Removing the vendored copy means changing that link in both files at once.
- The README currently says `i-have-adhd` is "bundled" and "an unmodified copy". Those statements go away if it is no longer vendored.

## Proposed commit sequence (once decisions are made)

1. Smoke-test Pstack and record the result. No repo change.
2. Add the run-start install step and the one failure line. Mirror it across both prompt copies.
3. Add Simple English to `goal.md` step 6. Mirror it.
4. Remove `skills/i-have-adhd/` and fix the `morning-handoff.md` link. Mirror it.
5. Rewrite the README: one install rule, no "bundled" language, an updated companion list and install section.
6. Update `EVALUATION_SCENARIOS.md` if the Pstack source or wiring changed.

Each commit should run on its own and pass the CI `cmp` check.

## Suggestion (parked, not started): ask how a change will be observed

Raised at the end of the session. The prompts do not require instrumentation today.

- `PLAN_PROMPT.md:19` lists "observability" inside the rollout dimension "as appropriate". The agent can mark that dimension "none".
- `GOAL_PROMPT.md` never mentions observability, tracing, metrics or logging. Step 5 asks for proof by tests, not by signals the shipped code emits.
- A run can finish with a verified draft PR and no new log line or span.

Proposed change: add one risk-proportional item to the Operational impact dimension in `PLAN_PROMPT.md` and a matching check in `GOAL_PROMPT.md` step 5. For changes that could fail or degrade in production, name how you would know: the signal (span, metric or log), where it lands, and who watches it. Small local changes would not need telemetry. Mirror both edits in `references/` because of the CI `cmp` check.

Keep this separate from the skill-embed work. It is a different change.

## Where I was wrong in this session

- I first read a **stale local checkout** (21 commits behind). My early answers described the old repo. I fixed this by running `git fetch` and `git pull --ff-only`.
- I said Pstack could not join the shared install model. That was wrong, and I corrected it after checking.
