#!/usr/bin/env bash
# Publish this checked-out folder as a new private GitHub repository.
set -euo pipefail

repo_name="${1:-agent-planning-prompts}"
if ! command -v gh >/dev/null 2>&1; then
  echo 'GitHub CLI (gh) is required: https://cli.github.com/' >&2
  exit 1
fi
if ! gh auth status >/dev/null 2>&1; then
  echo 'Please sign in to GitHub CLI first:' >&2
  echo '  gh auth login' >&2
  exit 1
fi

owner="$(gh api user --jq .login)"
full_repo="${owner}/${repo_name}"
if gh repo view "$full_repo" >/dev/null 2>&1; then
  echo "Repository already exists: https://github.com/${full_repo}" >&2
  echo 'Not uploading or changing its visibility.' >&2
  exit 1
fi
if [ ! -d .git ]; then
  git init -b main
fi
if git remote get-url origin >/dev/null 2>&1; then
  echo 'This folder already has an origin remote. Not altering it.' >&2
  exit 1
fi

git add README.md PLAN_PROMPT.md GOAL_PROMPT.md MORNING_HANDOFF.md publish.sh
if ! git diff --cached --quiet; then
  git commit -m 'Add reusable Plan and Goal prompts'
fi
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  echo 'No initial commit found.' >&2
  exit 1
fi

gh repo create "$full_repo" --private --source=. --remote=origin --push
visibility="$(gh repo view "$full_repo" --json visibility --jq .visibility)"
if [ "$visibility" != PRIVATE ]; then
  echo "ERROR: expected PRIVATE visibility, got: ${visibility}" >&2
  exit 1
fi
echo "Private repository created: https://github.com/${full_repo}"
