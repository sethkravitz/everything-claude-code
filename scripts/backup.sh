#!/bin/bash
# Backup current ~/.claude/ configuration
#
# Creates a timestamped backup of your production Claude Code config.
# Run this BEFORE deploying changes from staging.
#
# Usage: ./scripts/backup.sh

set -e

BACKUP_DIR="${HOME}/.claude-backups"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
BACKUP_PATH="${BACKUP_DIR}/claude_${TIMESTAMP}"

mkdir -p "$BACKUP_DIR"

echo "📦 Backing up ~/.claude/ to ${BACKUP_PATH}..."

# Copy config files (not runtime data)
mkdir -p "$BACKUP_PATH"
cp -r ~/.claude/CLAUDE.md "$BACKUP_PATH/" 2>/dev/null || true
cp -r ~/.claude/settings.json "$BACKUP_PATH/" 2>/dev/null || true
cp -r ~/.claude/commands "$BACKUP_PATH/" 2>/dev/null || true
cp -r ~/.claude/skills "$BACKUP_PATH/" 2>/dev/null || true
cp -r ~/.claude/agents "$BACKUP_PATH/" 2>/dev/null || true
cp -r ~/.claude/rules "$BACKUP_PATH/" 2>/dev/null || true
cp -r ~/.claude/hooks "$BACKUP_PATH/" 2>/dev/null || true
cp -r ~/.claude/contexts "$BACKUP_PATH/" 2>/dev/null || true
cp -r ~/.claude/bin "$BACKUP_PATH/" 2>/dev/null || true
cp -r ~/.claude/learned "$BACKUP_PATH/" 2>/dev/null || true

echo "✅ Backup complete: ${BACKUP_PATH}"
echo ""
echo "To restore: cp -r ${BACKUP_PATH}/* ~/.claude/"

# Keep only last 10 backups
ls -dt "${BACKUP_DIR}"/claude_* 2>/dev/null | tail -n +11 | xargs rm -rf 2>/dev/null || true
