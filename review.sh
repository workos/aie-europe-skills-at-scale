#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_FILE="$SCRIPT_DIR/.claude/skills/repo-roast/SKILL.md"
CONFIG_FILE="$SCRIPT_DIR/.share-config"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m'

usage() {
  echo "Usage: $0 [<number>|<id>] [--clear] [--restore]"
  echo ""
  echo "  (no args)   List shared skills"
  echo "  <number>    Load skill by list position"
  echo "  <id>        Load skill by ID"
  echo "  --restore   Restore the backed-up skill"
  echo "  --clear     Clear all submissions"
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

list_skills() {
  local response
  response=$(curl -s --max-time 10 "$SHARE_URL/skills")

  python3 -c "
import json, sys
data = json.loads(sys.stdin.read())
skills = data.get('skills', [])
if not skills:
    print('No submissions yet.')
    sys.exit(0)
print(f'  {len(skills)} submission(s):')
print()
print(f'  {\"#\":<4} {\"Name\":<20} {\"Time\":<8} {\"Size\":<8} ID')
print(f'  {\"-\"*4} {\"-\"*20} {\"-\"*8} {\"-\"*8} {\"-\"*16}')
for i, s in enumerate(skills, 1):
    t = s['timestamp'][11:16]
    sz = f\"{s.get('size', 0)}B\"
    print(f'  {i:<4} {s[\"name\"]:<20} {t:<8} {sz:<8} {s[\"id\"]}')
print()
print(f'  Run: ./review.sh <number> to load a skill')
" <<< "$response"
}

resolve_id() {
  local arg="$1"

  # If it's a small number, treat as list index
  if [[ "$arg" =~ ^[0-9]+$ ]] && [ "$arg" -lt 1000 ]; then
    local response
    response=$(curl -s --max-time 10 "$SHARE_URL/skills")
    python3 -c "
import json, sys
data = json.loads(sys.stdin.read())
skills = data.get('skills', [])
idx = int(sys.argv[1]) - 1
if idx < 0 or idx >= len(skills):
    print(f'ERROR:Index {idx+1} out of range (1-{len(skills)})', file=sys.stderr)
    sys.exit(1)
print(skills[idx]['id'])
" "$arg" <<< "$response"
  else
    echo "$arg"
  fi
}

fetch_skill() {
  local id="$1"
  local response
  response=$(curl -s --max-time 10 "$SHARE_URL/skills/$id")

  # Check for error
  if echo "$response" | python3 -c "import json,sys; d=json.loads(sys.stdin.read()); sys.exit(0 if 'skill' in d else 1)" 2>/dev/null; then
    # Backup current skill
    if [ -f "$SKILL_FILE" ]; then
      cp "$SKILL_FILE" "$SKILL_FILE.bak"
    fi

    # Extract and write skill
    python3 -c "
import json, sys
data = json.loads(sys.stdin.read())
print(data['skill'], end='')
" <<< "$response" > "$SKILL_FILE"

    local name
    name=$(python3 -c "import json,sys; print(json.loads(sys.stdin.read())['name'])" <<< "$response")

    echo ""
    echo -e "  ${GREEN}Loaded${NC} skill from ${BOLD}$name${NC}"
    echo -e "  ${YELLOW}Backed up${NC} previous skill to SKILL.md.bak"
    echo ""
    echo "  Now run your agent and ask it to roast a repo."
    echo "  Restore with: ./review.sh --restore"
  else
    echo -e "${RED}Error:${NC} Skill not found (id: $id)"
    exit 1
  fi
}

restore_skill() {
  if [ -f "$SKILL_FILE.bak" ]; then
    cp "$SKILL_FILE.bak" "$SKILL_FILE"
    echo -e "  ${GREEN}Restored${NC} skill from backup"
  else
    echo -e "${RED}Error:${NC} No backup file found"
    exit 1
  fi
}

clear_skills() {
  printf "Clear secret: "
  read -rs SECRET
  echo

  local http_code
  http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 \
    -X DELETE "$SHARE_URL/skills" \
    -H "X-Clear-Secret: $SECRET")

  if [ "$http_code" = "200" ]; then
    echo -e "  ${GREEN}Cleared${NC} all submissions."
  else
    echo -e "  ${RED}Failed${NC} (HTTP $http_code). Wrong secret?"
  fi
}

# Parse args
case "${1:-}" in
  --clear)
    clear_skills
    ;;
  --restore)
    restore_skill
    ;;
  --help|-h)
    usage
    ;;
  "")
    list_skills
    ;;
  *)
    ID=$(resolve_id "$1")
    fetch_skill "$ID"
    ;;
esac
