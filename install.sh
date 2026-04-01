#!/usr/bin/env bash
set -euo pipefail

REPO="AluciTech/aluci-label-helper"
VERSION=""
DEST_DIR=""

usage() {
  echo "Usage: curl -fsSL <url>/install.sh | bash -s -- [--version <tag>] <dest>"
  echo ""
  echo "Arguments:"
  echo "  <dest>   Destination folder for commands (e.g., .claude/ .opencode/)"
  echo ""
  echo "Options:"
  echo "  --version <tag>   Install a specific version (e.g., v1.0.0). Defaults to latest."
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      VERSION="${2:-}"
      if [[ -z "$VERSION" ]]; then
        echo "Error: --version requires a tag argument."
        exit 1
      fi
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      DEST_DIR="$1"
      shift
      ;;
  esac
done

if [[ -z "$DEST_DIR" ]]; then
  usage
  exit 1
fi

# Normalize: ensure dest ends with /commands
DEST_DIR="${DEST_DIR%/}"
case "$DEST_DIR" in
  */commands) ;;
  *) DEST_DIR="$DEST_DIR/commands" ;;
esac

# Resolve version to a git ref
if [[ -z "$VERSION" ]]; then
  REF="main"
else
  REF="$VERSION"
fi

RAW_BASE="https://raw.githubusercontent.com/$REPO/$REF/commands"
API_URL="https://api.github.com/repos/$REPO/contents/commands?ref=$REF"

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

# List all .md files in the commands/ directory via GitHub API
list_commands() {
  local files
  files=$(curl -fsSL "$API_URL" | grep '"name"' | sed 's/.*"name": *"\([^"]*\)".*/\1/' | grep '\.md$')
  if [[ -z "$files" ]]; then
    echo "Error: no commands found in $API_URL"
    exit 1
  fi
  echo "$files"
}

install_command() {
  local filename="$1"
  local dest="$DEST_DIR/$filename"

  if confirm_overwrite "$dest"; then
    mkdir -p "$DEST_DIR"
    echo "Downloading $filename..."
    curl -fsSL "$RAW_BASE/$filename" -o "$dest"
    echo "  installed $dest"
  fi
}

echo "Installing commands to $DEST_DIR/"

commands=$(list_commands)
while IFS= read -r cmd; do
  install_command "$cmd"
done <<< "$commands"

echo ""
echo "Done! All commands have been installed."
