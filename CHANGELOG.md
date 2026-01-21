# Changelog

All notable changes to the Claude Code configuration.

---

## [2026-01-21] - Repository Restructure

### Added
- **staging/** - Production-clone testing environment
  - Copied CLAUDE.md from ~/.claude/
  - Copied settings.json from ~/.claude/
  - Copied all 7 commands (autonomous, brief, careful, end, evolve, review, spike)
  - Copied coding-standards skill
  - Copied bin utilities (trash system)
  - Created empty directories: agents/, rules/, hooks/, contexts/, learned/

- **scripts/** - Deployment automation
  - `backup.sh` - Timestamped backups of ~/.claude/
  - `deploy.sh` - Safe deployment from staging to production
  - `diff.sh` - Compare staging vs production configs
  - `consolidate-learnings.sh` - Weekly self-improvement review

- **docs/** - Architecture documentation
  - `architecture.md` - Component definitions and context budget
  - `decision-tree.md` - When to use commands, agents, modes
  - `troubleshooting.md` - Common issues and solutions

- **reference/hackathon-winner/** - Original everything-claude-code configs
  - 9 agents (security-reviewer, code-reviewer, build-error-resolver, etc.)
  - 10+ skills (coding-standards, backend-patterns, tdd-workflow, etc.)
  - 10 commands (/tdd, /plan, /e2e, etc.)
  - 8 rules (security, coding-style, testing, etc.)
  - 18 hooks configuration
  - 3 context modes (dev, research, review)
  - MCP server examples
  - Example CLAUDE.md templates

- **RESEARCH.md** - Links and analysis notes
- **CHANGELOG.md** - This file

### Changed
- **README.md** - Rewritten for staging environment purpose

### Removed
- Root-level configs moved to reference/hackathon-winner/

---

## Future Changes

### Planned
- [ ] Add agents from reference/ to staging/agents/
- [ ] Configure hooks in staging/settings.json
- [ ] Modularize CLAUDE.md into staging/rules/
- [ ] Add context modes to staging/contexts/
- [ ] Install Vercel react-best-practices skill
- [ ] Create project-specific skills (ai-sdk, deployment, ops-setup)

### Considerations
- Keep rules under 150 lines combined
- Use hooks for enforcement, not just rules
- Write learnings to dated files, consolidate weekly
- Test all changes before deploying to production
