#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_SRC="$SCRIPT_DIR/.claude/skills/repo-roast"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

usage() {
  echo "Usage: $0 [--cleanup] [--checkpoint N]"
  echo ""
  echo "  (no args)        Symlink the repo-roast skill for your coding agent"
  echo "  --checkpoint N   Copy checkpoint N (0-3) as your active skill"
  echo "  --cleanup        Remove symlinks created by this script"
  exit 0
}

cleanup() {
  echo "Cleaning up symlinks..."
  local removed=0

  if [ -L "$HOME/.claude/skills/repo-roast" ]; then
    rm "$HOME/.claude/skills/repo-roast"
    echo -e "  ${GREEN}Removed${NC} ~/.claude/skills/repo-roast"
    removed=$((removed + 1))
  fi

  if [ -L "$HOME/.agents/skills/repo-roast" ]; then
    rm "$HOME/.agents/skills/repo-roast"
    echo -e "  ${GREEN}Removed${NC} ~/.agents/skills/repo-roast"
    removed=$((removed + 1))
  fi

  if [ "$removed" -eq 0 ]; then
    echo "  Nothing to clean up."
  fi
  exit 0
}

install() {
  echo "Setting up repo-roast skill..."
  echo ""

  # Detect available tools
  local has_claude=false has_codex=false
  command -v claude >/dev/null 2>&1 && has_claude=true
  command -v codex >/dev/null 2>&1 && has_codex=true

  if ! $has_claude && ! $has_codex; then
    echo -e "${YELLOW}Warning:${NC} Neither 'claude' nor 'codex' found in PATH."
    echo "  Install Claude Code: https://docs.anthropic.com/en/docs/claude-code"
    echo "  Install Codex: https://github.com/openai/codex"
    echo ""
    echo "  Continuing anyway — symlinks will be ready when you install a tool."
    echo ""
  fi

  # Claude Code: ~/.claude/skills/repo-roast
  if $has_claude || ! $has_codex; then
    mkdir -p "$HOME/.claude/skills"
    if [ -L "$HOME/.claude/skills/repo-roast" ]; then
      echo -e "  ${YELLOW}Exists${NC} ~/.claude/skills/repo-roast (already symlinked)"
    elif [ -d "$HOME/.claude/skills/repo-roast" ]; then
      echo -e "  ${YELLOW}Exists${NC} ~/.claude/skills/repo-roast (real directory — skipping)"
    else
      ln -s "$SKILL_SRC" "$HOME/.claude/skills/repo-roast"
      echo -e "  ${GREEN}Linked${NC} ~/.claude/skills/repo-roast -> $SKILL_SRC"
    fi
  fi

  # Codex: ~/.agents/skills/repo-roast
  if $has_codex; then
    mkdir -p "$HOME/.agents/skills"
    if [ -L "$HOME/.agents/skills/repo-roast" ]; then
      echo -e "  ${YELLOW}Exists${NC} ~/.agents/skills/repo-roast (already symlinked)"
    elif [ -d "$HOME/.agents/skills/repo-roast" ]; then
      echo -e "  ${YELLOW}Exists${NC} ~/.agents/skills/repo-roast (real directory — skipping)"
    else
      ln -s "$SKILL_SRC" "$HOME/.agents/skills/repo-roast"
      echo -e "  ${GREEN}Linked${NC} ~/.agents/skills/repo-roast -> $SKILL_SRC"
    fi
  fi

  echo ""
  echo "Done. The repo-roast skill is now available globally."
  echo "  Edit: $SKILL_SRC/SKILL.md"
  echo "  Test: Open any repo and run /repo-roast"
  echo ""
  echo "To remove: $0 --cleanup"
}

checkpoint() {
  local num="${1:-}"
  local map_0="$SCRIPT_DIR/checkpoints/0-bad-skill.md"
  local map_1="$SCRIPT_DIR/checkpoints/1-starter.md"
  local map_2="$SCRIPT_DIR/checkpoints/2-with-phases.md"
  local map_3="$SCRIPT_DIR/checkpoints/3-complete.md"

  local src_var="map_${num}"
  local src="${!src_var:-}"

  if [ -z "$src" ] || [ ! -f "$src" ]; then
    echo -e "${RED}Error:${NC} Invalid checkpoint '$num'. Use 0, 1, 2, or 3."
    exit 1
  fi

  cp "$src" "$SKILL_SRC/SKILL.md"
  echo -e "  ${GREEN}Loaded${NC} checkpoint $num -> $SKILL_SRC/SKILL.md"
}

# Parse args
case "${1:-}" in
  --checkpoint) checkpoint "${2:-}" ;;
  --cleanup|--uninstall|--remove) cleanup ;;
  --help|-h) usage ;;
  "") install ;;
  *) echo "Unknown option: $1"; usage ;;
esac
