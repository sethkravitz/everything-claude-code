#!/bin/bash
# Consolidate Learnings - Weekly review of self-improvement archive
#
# Reviews files in ~/.claude/learned/ (or staging/learned/) and helps you:
# 1. Promote frequent patterns to permanent rules
# 2. Archive one-off fixes
# 3. Delete noise
#
# Usage: ./scripts/consolidate-learnings.sh [--staging]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Default to production, --staging to use staging dir
if [[ "$1" == "--staging" ]]; then
  LEARNED_DIR="${REPO_ROOT}/staging/learned"
  RULES_DIR="${REPO_ROOT}/staging/rules"
else
  LEARNED_DIR="${HOME}/.claude/learned"
  RULES_DIR="${HOME}/.claude/rules"
fi

ARCHIVE_DIR="${LEARNED_DIR}/archive"

# Colors
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "📚 Consolidating Learnings"
echo "=========================================="
echo "Source: ${LEARNED_DIR}"
echo ""

# Check if learned directory exists and has files
if [[ ! -d "$LEARNED_DIR" ]]; then
  echo "No learned/ directory found. Nothing to consolidate."
  exit 0
fi

learnings=$(find "$LEARNED_DIR" -maxdepth 1 -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')

if [[ "$learnings" == "0" ]]; then
  echo "✓ No new learnings to review."
  exit 0
fi

echo -e "${YELLOW}Found ${learnings} learning file(s) to review:${NC}"
echo ""

mkdir -p "$ARCHIVE_DIR"
mkdir -p "$RULES_DIR"

# List each learning file with its content preview
for file in "$LEARNED_DIR"/*.md; do
  [[ -f "$file" ]] || continue

  filename=$(basename "$file")
  echo -e "${BLUE}━━━ ${filename} ━━━${NC}"
  head -20 "$file"
  echo ""
  echo -e "${YELLOW}What should we do with this learning?${NC}"
  echo "  [p] Promote to rules/ (permanent)"
  echo "  [a] Archive (keep but don't load)"
  echo "  [d] Delete (noise)"
  echo "  [s] Skip (review later)"
  echo ""
  read -p "Action [p/a/d/s]: " action

  case "$action" in
    p|P)
      echo "Which rule file should this go in?"
      ls "$RULES_DIR" 2>/dev/null || echo "(no existing rules)"
      read -p "Rule file name (e.g., verification.md): " rulefile
      if [[ -n "$rulefile" ]]; then
        echo "" >> "${RULES_DIR}/${rulefile}"
        echo "# From ${filename}" >> "${RULES_DIR}/${rulefile}"
        cat "$file" >> "${RULES_DIR}/${rulefile}"
        rm "$file"
        echo -e "${GREEN}✓ Promoted to rules/${rulefile}${NC}"
      fi
      ;;
    a|A)
      mv "$file" "$ARCHIVE_DIR/"
      echo -e "${GREEN}✓ Archived${NC}"
      ;;
    d|D)
      rm "$file"
      echo -e "${GREEN}✓ Deleted${NC}"
      ;;
    s|S)
      echo "Skipped"
      ;;
    *)
      echo "Skipped (unknown action)"
      ;;
  esac
  echo ""
done

echo "=========================================="
echo "✅ Consolidation complete!"
echo ""
echo "Summary:"
echo "  Rules: $(ls "$RULES_DIR" 2>/dev/null | wc -l | tr -d ' ') files"
echo "  Archived: $(ls "$ARCHIVE_DIR" 2>/dev/null | wc -l | tr -d ' ') files"
echo "  Pending: $(find "$LEARNED_DIR" -maxdepth 1 -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ') files"
