# Claude Code Architecture

This document explains how all Claude Code configuration components work together.

## Component Types

### What Loads When (Context Budget)

| Component | When Loaded | Context Cost | Notes |
|-----------|-------------|--------------|-------|
| **CLAUDE.md** | Session start | Heavy | Keep to ~50-100 lines |
| **Rules** (`rules/`) | Session start | Heavy | Each file loads. Keep lean. |
| **MCP tools** | Session start | Medium | ~100 tokens per MCP server |
| **Skill descriptions** | Session start | Light | ~100 tokens each |
| **Skill full content** | On activation | Heavy | Only when used |
| **Commands** | On `/invoke` | Heavy | Only when called |
| **Agents** | On spawn | Zero main context | Isolated subcontext |
| **Hooks** | Never in context | Zero | Bash scripts, not prompts |

### Context Budget Guidelines

| Context % Used | Quality | Recommendation |
|----------------|---------|----------------|
| 0-40% | Excellent | Optimal zone |
| 40-60% | Good | Still effective |
| 60-80% | Degrading | Start being selective |
| 80-95% | Poor | Manual compaction needed |
| 95-100% | Critical | "The last 20% is poison" |

## Component Definitions

### CLAUDE.md
Global instructions loaded at session start. Keep minimal - critical rules only.

Location: `~/.claude/CLAUDE.md` (global) or project root (project-specific)

### Rules (`rules/`)
Modular rule files that always load. Separate concerns into focused files:
- `hard-stops.md` - Non-negotiable constraints
- `verification.md` - How to verify work
- `safety.md` - Dangerous operations
- `testing.md` - Test requirements

### Commands (`commands/`)
User-invoked workflows via `/command-name`. Only load when called.

Your commands:
- `/autonomous` - 10-phase planned feature work
- `/careful` - Step-by-step with approvals
- `/spike` - 90-min rapid validation (TDD suspended)
- `/review` - Code audit
- `/brief` - Create Grade A briefs
- `/evolve` - Skeptical resource evaluation
- `/end` - Session cleanup

### Skills (`skills/`)
Domain-specific context that loads on-demand. Only descriptions load at start.

Structure:
```
skill-name/
├── SKILL.md         # Main instructions (<5000 words)
├── scripts/         # Python/Bash automation
├── references/      # Docs loaded via Read
└── assets/          # Templates (referenced, not loaded)
```

### Agents (`agents/`)
Isolated subagents spawned via Task tool. Zero impact on main context.

Use for:
- Security review
- Code review
- Build error resolution
- TDD guidance
- Architecture decisions

### Hooks (in `settings.json`)
Bash scripts triggered on lifecycle events. Zero context cost.

Events:
- `PreToolUse` - Before tool executes (can block)
- `PostToolUse` - After tool executes
- `PreCompact` - Before context compaction
- `SessionStart` - When session begins
- `Stop` - When Claude would stop

### Contexts (`contexts/`)
Mode toggles that change Claude's behavior:
- `dev.md` - Write code first, explain after
- `research.md` - Analyze thoroughly, no code yet
- `review.md` - Security-first audit mode

## Rules + Hooks = Enforcement

Rules declare intent, hooks enforce compliance:

| Rule | Enforcing Hook | Event |
|------|----------------|-------|
| NEVER console.log | `warn-console-log.sh` | PostToolUse |
| NEVER --no-verify | `block-no-verify.sh` | PreToolUse |
| ALWAYS run tsc | `run-tsc.sh` | PostToolUse |
| NEVER edit main branch | `block-main-edits.sh` | PreToolUse |

## Self-Improvement Flow

```
Mistake happens
    ↓
"Reflect on this mistake. Write to ~/.claude/learned/$(date +%Y-%m-%d).md"
    ↓
Claude writes learning to DATED FILE (not CLAUDE.md)
    ↓
Stop hook counts unreviewed learnings
    ↓
If > 5 new: "[Hook] Run /consolidate-learnings to review"
    ↓
Weekly: ./scripts/consolidate-learnings.sh
    ↓
Promote frequent patterns → rules/
Archive one-offs
Delete noise
    ↓
Rules stay lean. Learnings compound.
```

## Directory Structure

```
~/.claude/
├── CLAUDE.md           # Global instructions (minimal)
├── settings.json       # Hooks, permissions, plugins
├── agents/             # Specialized subagents
├── commands/           # Slash commands
├── skills/             # Domain knowledge
├── rules/              # Always-loaded rules
├── hooks/              # Hook scripts (.sh files)
├── contexts/           # Mode toggles
├── learned/            # Self-improvement archive
└── bin/                # Utility scripts (trash, etc.)
```
