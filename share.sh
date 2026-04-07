#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_FILE="$SCRIPT_DIR/.claude/skills/repo-roast/SKILL.md"
CONFIG_FILE="$SCRIPT_DIR/.share-config"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

usage() {
  echo "Usage: $0 [--name \"Your Name\"]"
  echo ""
  echo "  Share your Repo Roast skill with the presenter."
  echo "  Reads from .claude/skills/repo-roast/SKILL.md"
  exit 0
}

# Load endpoint URL
SHARE_URL="${SHARE_URL:-}"
if [ -z "$SHARE_URL" ] && [ -f "$CONFIG_FILE" ]; then
  SHARE_URL="$(tr -d '[:space:]' < "$CONFIG_FILE")"
fi
if [ -z "$SHARE_URL" ]; then
  echo -e "${RED}Error:${NC} No endpoint URL. Set SHARE_URL or check .share-config"
  exit 1
fi

# Check skill file
if [ ! -f "$SKILL_FILE" ]; then
  echo -e "${RED}Error:${NC} No skill file at $SKILL_FILE"
  echo "  Run ./setup.sh first, then edit your skill."
  exit 1
fi

# Parse args
NAME=""
case "${1:-}" in
  --name)
    NAME="${2:-}"
    ;;
  --help|-h)
    usage
    ;;
  "")
    ;;
  *)
    echo "Unknown option: $1"; usage
    ;;
esac

# Prompt for name if not provided
if [ -z "$NAME" ]; then
  printf "Your name (shown on screen): "
  read -r NAME
fi
if [ -z "$NAME" ]; then
  echo -e "${RED}Error:${NC} Name cannot be empty"
  exit 1
fi

# Share it
echo "Sharing your skill..."
RESPONSE=$(curl -s -w "\n%{http_code}" --max-time 10 -X POST "$SHARE_URL/share" \
  -F "name=$NAME" \
  -F "skill=@$SKILL_FILE")

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "201" ]; then
  echo -e "${GREEN}Shared!${NC} Your skill is now visible to the presenter."
else
  echo -e "${RED}Failed${NC} (HTTP $HTTP_CODE): $BODY"
  exit 1
fi
