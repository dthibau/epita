#!/usr/bin/env bash
# Creates GitHub task issues from user stories.
# Usage: ./create-tasks.sh [--repo owner/repo] [--label task]
# Requires: gh CLI authenticated (gh auth login)

set -euo pipefail

LABEL="task"
REPO_FLAG=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --repo) REPO_FLAG="--repo $2"; shift 2 ;;
    --label) LABEL="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

create_issue() {
  local title="$1"
  local body="$2"
  echo "Creating issue: Task: $title"
  # shellcheck disable=SC2086
  gh issue create \
    $REPO_FLAG \
    --title "Task: $title" \
    --body "$body" \
    --label "$LABEL"
  echo "Done: Task: $title"
}