#!/bin/bash
# Compare staging/ vs production ~/.claude/
#
# Shows what's different between your staging config and production.
# Useful before deploying to see what will change.
#
# Usage: ./scripts/diff.sh [file-or-dir]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
STAGING_DIR="${REPO_ROOT}/staging"
TARGET_DIR="${HOME}/.claude"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "📊 Comparing staging/ vs ~/.claude/"
echo "=========================================="
echo ""

# If specific file provided, diff just that
if [[ -n "$1" ]]; then
  echo "Comparing: $1"
  diff -u "${TARGET_DIR}/$1" "${STAGING_DIR}/$1" 2>/dev/null || echo "Files differ or don't exist in both locations"
  exit 0
fi

# Compare main config files
echo -e "${YELLOW}=== CLAUDE.md ===${NC}"
if diff -q "${TARGET_DIR}/CLAUDE.md" "${STAGING_DIR}/CLAUDE.md" >/dev/null 2>&1; then
  echo -e "${GREEN}✓ Identical${NC}"
else
  echo -e "${RED}✗ Different${NC}"
  diff --color=auto "${TARGET_DIR}/CLAUDE.md" "${STAGING_DIR}/CLAUDE.md" 2>/dev/null | head -20 || true
fi
echo ""

echo -e "${YELLOW}=== settings.json ===${NC}"
if diff -q "${TARGET_DIR}/settings.json" "${STAGING_DIR}/settings.json" >/dev/null 2>&1; then
  echo -e "${GREEN}✓ Identical${NC}"
else
  echo -e "${RED}✗ Different${NC}"
  echo "(Use 'diff ~/.claude/settings.json staging/settings.json' for full diff)"
fi
echo ""

# Compare directories
for dir in commands skills agents rules hooks contexts bin; do
  echo -e "${YELLOW}=== ${dir}/ ===${NC}"

  # Files only in production
  prod_only=$(comm -23 <(ls "${TARGET_DIR}/${dir}" 2>/dev/null | sort) <(ls "${STAGING_DIR}/${dir}" 2>/dev/null | sort) 2>/dev/null || true)
  if [[ -n "$prod_only" ]]; then
    echo -e "${RED}In ~/.claude only:${NC} $prod_only"
  fi

  # Files only in staging
  staging_only=$(comm -13 <(ls "${TARGET_DIR}/${dir}" 2>/dev/null | sort) <(ls "${STAGING_DIR}/${dir}" 2>/dev/null | sort) 2>/dev/null || true)
  if [[ -n "$staging_only" ]]; then
    echo -e "${GREEN}In staging only:${NC} $staging_only"
  fi

  # Files in both - check for differences
  common=$(comm -12 <(ls "${TARGET_DIR}/${dir}" 2>/dev/null | sort) <(ls "${STAGING_DIR}/${dir}" 2>/dev/null | sort) 2>/dev/null || true)
  for file in $common; do
    if ! diff -q "${TARGET_DIR}/${dir}/${file}" "${STAGING_DIR}/${dir}/${file}" >/dev/null 2>&1; then
      echo -e "${YELLOW}Modified:${NC} ${file}"
    fi
  done

  if [[ -z "$prod_only" && -z "$staging_only" ]]; then
    prod_count=$(ls "${TARGET_DIR}/${dir}" 2>/dev/null | wc -l | tr -d ' ')
    staging_count=$(ls "${STAGING_DIR}/${dir}" 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$prod_count" == "$staging_count" && "$prod_count" != "0" ]]; then
      echo -e "${GREEN}✓ Synced (${prod_count} files)${NC}"
    elif [[ "$prod_count" == "0" && "$staging_count" == "0" ]]; then
      echo "(empty)"
    fi
  fi
  echo ""
done

echo "=========================================="
echo "Run './scripts/diff.sh <path>' to see specific file differences"
