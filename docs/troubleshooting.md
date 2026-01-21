# Troubleshooting Guide

Common issues and solutions for Claude Code configuration.

## Context Issues

### Problem: Claude ignoring instructions
**Symptoms**: Claude doesn't follow rules in CLAUDE.md

**Solutions**:
1. Rules might be too long - keep CLAUDE.md under 100 lines
2. Use absolute directives: "NEVER" and "ALWAYS", not "try to" or "prefer"
3. Move critical rules to `rules/` directory for emphasis
4. Add hooks to enforce rules automatically

### Problem: Context window filling too fast
**Symptoms**: Quality degrades, Claude forgets earlier context

**Solutions**:
1. Check MCP server count - keep under 10
2. Use agents for exploration (isolated context)
3. Manual compaction at logical breakpoints
4. Keep CLAUDE.md + rules under 150 lines total

### Problem: Hooks adding latency
**Symptoms**: Noticeable pause on every tool use

**Solutions**:
1. Add timeouts to hooks (default 60s)
2. Use `|| true` for non-critical hooks
3. Only hook essential events
4. Move heavy processing to Stop hooks (runs once)

## Hook Issues

### Problem: Hook not running
**Symptoms**: Expected automation not happening

**Solutions**:
1. Check matcher pattern - must match tool name exactly
2. Verify script is executable: `chmod +x script.sh`
3. Check script path is absolute or uses `~`
4. Test script manually first

### Problem: Hook blocking unexpectedly
**Symptoms**: Claude can't proceed, action blocked

**Solutions**:
1. PreToolUse exit code 2 = block, 0 = allow
2. Check for typos in conditional logic
3. Add `2>/dev/null || true` for graceful failures
4. Review the hook's matcher pattern

### Problem: Hook not receiving environment variables
**Symptoms**: Script can't access `$CLAUDE_FILE_PATH` etc.

**Solutions**:
1. Variables only available for relevant hooks
2. Use `echo "$CLAUDE_FILE_PATH"` for debugging
3. Check you're using the correct variable name
4. Ensure script has proper shebang (`#!/bin/bash`)

## Command Issues

### Problem: Command not found
**Symptoms**: `/mycommand` doesn't work

**Solutions**:
1. File must be in `~/.claude/commands/` (not `commands/`)
2. Filename must be `command-name.md`
3. Check for typos in filename
4. Restart Claude Code session

### Problem: Command loading wrong content
**Symptoms**: Command behaves differently than expected

**Solutions**:
1. Check for duplicate command names
2. Verify file content hasn't been corrupted
3. Clear any cached sessions
4. Use `./scripts/diff.sh` to compare staging vs production

## Agent Issues

### Problem: Agent not spawning
**Symptoms**: Task tool fails or returns error

**Solutions**:
1. Check agent file exists in `~/.claude/agents/`
2. Verify agent file format is valid markdown
3. Check for syntax errors in agent configuration
4. Try spawning a built-in agent first to verify setup

### Problem: Agent losing context
**Symptoms**: Agent asks for information you already provided

**Solutions**:
1. Include all necessary context in the spawn prompt
2. Agents don't inherit main conversation context
3. Be explicit about what files to read
4. Consider if task is better suited for main conversation

## Deployment Issues

### Problem: Changes not taking effect
**Symptoms**: Deployed changes not visible in new sessions

**Solutions**:
1. Start a NEW Claude Code session (not continue existing)
2. Verify deployment with `./scripts/diff.sh`
3. Check file permissions on deployed files
4. Confirm correct directory (`~/.claude/` not `~/.config/`)

### Problem: Backup/restore not working
**Symptoms**: Can't recover previous configuration

**Solutions**:
1. Check `~/.claude-backups/` exists
2. Backups are timestamped - find correct one
3. Restore with `cp -r ~/.claude-backups/claude_<timestamp>/* ~/.claude/`
4. Only 10 most recent backups kept

## Self-Improvement Issues

### Problem: Learnings not being captured
**Symptoms**: `~/.claude/learned/` is empty

**Solutions**:
1. Use the magic prompt: "Reflect on this mistake. Write to ~/.claude/learned/$(date +%Y-%m-%d).md"
2. Ensure `learned/` directory exists
3. Check file permissions
4. Verify Claude has write access

### Problem: Rules getting bloated
**Symptoms**: CLAUDE.md or rules/ growing too large

**Solutions**:
1. Run `./scripts/consolidate-learnings.sh` regularly
2. Archive one-off learnings, don't promote everything
3. Combine similar rules into single entries
4. Delete rules that are no longer relevant

## Quick Fixes

### Reset to known good state
```bash
./scripts/backup.sh           # Save current state
cp -r ~/.claude-backups/claude_<good_timestamp>/* ~/.claude/
```

### Compare staging vs production
```bash
./scripts/diff.sh
```

### Test hook manually
```bash
export CLAUDE_FILE_PATH="/path/to/file.ts"
./staging/hooks/my-hook.sh
echo $?  # Check exit code
```

### Verify configuration
```bash
ls -la ~/.claude/           # Check structure
cat ~/.claude/CLAUDE.md     # Check instructions
cat ~/.claude/settings.json | jq '.hooks' # Check hooks
```
