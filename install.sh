#!/usr/bin/env bash
set -euo pipefail

BASE_URL="https://raw.githubusercontent.com/AluciTech/aluci-label-reviewer/main"
TOOL="${1:-}"

usage() {
  echo "Usage: curl -fsSL <url>/install.sh | bash -s -- <tool>"
  echo ""
  echo "Tools:"
  echo "  claude     Install for Claude Code (.claude/commands/)"
  echo "  opencode   Install for OpenCode (.opencode/commands/)"
  echo "  all        Install for both"
}

confirm_overwrite() {
  local file="$1"
  if [ -f "$file" ]; then
    printf "%s already exists. Overwrite? [y/N] " "$file"
    read -r answer </dev/tty
    case "$answer" in
      [yY][eE][sS]|[yY]) return 0 ;;
      *) echo "Skipping $file."; return 1 ;;
    esac
  fi
  return 0
}

install_claude() {
  mkdir -p .claude/commands
  local dest=".claude/commands/pre-review.md"
  if confirm_overwrite "$dest"; then
    echo "Downloading $dest..."
    curl -fsSL "$BASE_URL/commands/pre-review.md" -o "$dest"
  fi
}

install_opencode() {
  mkdir -p .opencode/commands
  local dest=".opencode/commands/pre-review.md"
  if confirm_overwrite "$dest"; then
    echo "Downloading $dest..."
    curl -fsSL "$BASE_URL/commands/pre-review.md" -o "$dest"
  fi
}

case "$TOOL" in
  claude)
    install_claude
    ;;
  opencode)
    install_opencode
    ;;
  all)
    install_claude
    install_opencode
    ;;
  *)
    usage
    exit 1
    ;;
esac

echo "Done! Run /pre-review from your coding agent to start a pre-review."
