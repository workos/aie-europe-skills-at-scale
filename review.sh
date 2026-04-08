#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/.claude/skills"
CONFIG_FILE="$SCRIPT_DIR/.share-config"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m'

usage() {
  echo "Usage: $0 [<number>|<id>] [--clean] [--clear]"
  echo ""
  echo "  (no args)   List shared skills"
  echo "  <number>    Load skill by list position"
  echo "  <id>        Load skill by ID"
  echo "  --clean     Remove all downloaded skills"
  echo "  --clear     Clear all submissions (server)"
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
    # Extract name and content
    local name skill_content
    name=$(python3 -c "import json,sys; print(json.loads(sys.stdin.read())['name'])" <<< "$response")
    skill_content=$(python3 -c "import json,sys; print(json.loads(sys.stdin.read())['skill'], end='')" <<< "$response")

    # Sanitize name for directory
    local safe_name
    safe_name=$(echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
    local target_dir="$SKILLS_DIR/repo-roast-$safe_name"

    # Clean target if it already exists
    rm -rf "$target_dir"
    mkdir -p "$target_dir"

    # Detect text bundle (====FILE:...====) vs plain SKILL.md
    if echo "$skill_content" | head -1 | grep -q "^====FILE:"; then
      python3 -c "
import sys, os
content = sys.stdin.read()
target = sys.argv[1]
for block in content.split('====FILE:')[1:]:
    if '====' not in block:
        continue
    header, _, body = block.partition('====\n')
    body = body.split('\n====END_BUNDLE====')[0].rstrip('\n')
    filepath = os.path.join(target, header.strip())
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    with open(filepath, 'w') as f:
        f.write(body)
        f.write('\n')
" "$target_dir" <<< "$skill_content"
    else
      echo "$skill_content" > "$target_dir/SKILL.md"
    fi

    # Rename the skill in frontmatter so Claude sees it as distinct
    if [ -f "$target_dir/SKILL.md" ]; then
      sed -i '' "s/^name: .*/name: repo-roast-$safe_name/" "$target_dir/SKILL.md"
    fi

    local file_count
    file_count=$(find "$target_dir" -type f | wc -l | tr -d ' ')

    echo ""
    echo -e "  ${GREEN}Loaded${NC} skill from ${BOLD}$name${NC} ($file_count file(s))"
    echo -e "  → .claude/skills/repo-roast-$safe_name/"
    echo ""
    echo "  Now ask Claude to use repo-roast-$safe_name to roast a repo."
    echo "  Clean up with: ./review.sh --clean"
  else
    echo -e "${RED}Error:${NC} Skill not found (id: $id)"
    exit 1
  fi
}

clean_skills() {
  local count=0
  for dir in "$SKILLS_DIR"/repo-roast-*/; do
    [ -d "$dir" ] || continue
    rm -rf "$dir"
    count=$((count + 1))
  done
  if [ "$count" -gt 0 ]; then
    echo -e "  ${GREEN}Removed${NC} $count downloaded skill(s)"
  else
    echo "  No downloaded skills to clean."
  fi
}

clear_server() {
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
  --clean)
    clean_skills
    ;;
  --clear)
    clear_server
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
