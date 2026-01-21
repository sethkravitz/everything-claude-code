#!/bin/bash
# Deploy staging/ configuration to ~/.claude/
#
# Copies tested configuration from staging/ to production ~/.claude/.
# ALWAYS run backup.sh first!
#
# Usage: ./scripts/deploy.sh [--force]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
STAGING_DIR="${REPO_ROOT}/staging"
TARGET_DIR="${HOME}/.claude"

# Check for --force flag
FORCE=false
if [[ "$1" == "--force" ]]; then
  FORCE=true
fi

if [[ ! -d "$STAGING_DIR" ]]; then
  echo "❌ Error: staging/ directory not found at ${STAGING_DIR}"
  exit 1
fi

# Safety check: require backup unless forced
if [[ "$FORCE" != true ]]; then
  echo "⚠️  This will overwrite your ~/.claude/ configuration!"
  echo ""
  echo "Have you run ./scripts/backup.sh first? (y/n)"
  read -r response
  if [[ "$response" != "y" && "$response" != "Y" ]]; then
    echo "Run ./scripts/backup.sh first, then try again."
    exit 1
  fi
fi

echo "🚀 Deploying staging/ to ~/.claude/..."

# Deploy config files
cp "${STAGING_DIR}/CLAUDE.md" "${TARGET_DIR}/" 2>/dev/null || true
cp "${STAGING_DIR}/settings.json" "${TARGET_DIR}/" 2>/dev/null || true

# Deploy directories (create if missing, merge contents)
for dir in commands skills agents rules hooks contexts bin learned; do
  if [[ -d "${STAGING_DIR}/${dir}" ]]; then
    mkdir -p "${TARGET_DIR}/${dir}"
    cp -r "${STAGING_DIR}/${dir}/"* "${TARGET_DIR}/${dir}/" 2>/dev/null || true
    echo "  ✓ Deployed ${dir}/"
  fi
done

echo ""
echo "✅ Deploy complete!"
echo ""
echo "Changes deployed. Start a new Claude Code session to test."
echo "If issues arise, restore from backup: cp -r ~/.claude-backups/claude_<timestamp>/* ~/.claude/"
