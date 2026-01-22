# Changelog

All notable changes to the Claude Code configuration.

---

## [2026-01-22] - X.com Evaluator Tool

### Added
- **tools/x-evaluator/** - X.com post fetcher for resource evaluation
  - `fetch-x-post-openrouter.js` - OpenRouter + Grok API integration for reliable X.com post fetching
  - `fetch-x-post.js` - Direct X.ai API version (non-functional, kept for reference)
  - `evaluate.sh` - Smart router script that detects X.com URLs and routes to appropriate fetcher
  - Zero dependencies (Node.js stdlib only)

- **.claude/commands/evaluate.md** - Project-specific evaluation command
  - Loads EVALUATE.md framework automatically
  - Auto-detects X.com URLs and uses appropriate fetcher
  - Handles all resource types: URLs, PDFs, screenshots, descriptions
  - Enforces skeptical evaluation approach
  - Tracks evaluations in RESEARCH.md

- **.env** and **.env.example** - Project-specific environment configuration
  - Stores OPENROUTER_API_KEY locally in project
  - No need to pollute global shell config
  - Fetcher scripts automatically load from .env file
  - More portable for other users

- **.claude/settings.json** - Project-specific permissions
  - Auto-allows node and bash commands for x-evaluator tools
  - No manual approval needed when running evaluation scripts
  - Only applies to this project

### Changed
- **EVALUATE.md** - Added "Fetching Content" section
  - Documents X.com URL handling via OpenRouter-based fetcher
  - Clarifies WebFetch handles all other URL types
  - Includes setup instructions for OPENROUTER_API_KEY

- **README.md** - Added Tools section
  - Documented X.com evaluator purpose, setup, and usage
  - Updated repository structure to include tools/ directory

### Fixed
- **fetch-x-post-openrouter.js** - Production hardening
  - Added error handling for .env file read failures
  - Fixed HTTP-Referer header placeholder URL
  - Improved error messages with fallback instructions

- **evaluate.sh** - Security and reliability improvements
  - Replaced `echo | grep` with bash regex (prevents command injection)
  - Added `set -e` for fail-fast behavior
  - Proper exit code propagation from node script

### Context
X.com blocks standard web scraping, making it impossible to evaluate X.com-based Claude Code techniques without specialized tooling. The Grok API (from xAI, same company as X.com) provides reliable access when used via OpenRouter with web search enabled. Direct X.ai API proved unreliable during spike testing, returning hallucinated content even with correct parameters.

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

## [2026-01-21] - Phase 2-4: Rules, Hooks, Agents, Contexts

### Added
- **staging/rules/** - Modularized rules (147 lines total)
  - `hard-stops.md` (33 lines) - Commit blockers, pre-commit checks
  - `verification.md` (44 lines) - Verification mindset, failure patterns
  - `safety.md` (35 lines) - Dangerous operations, trash policy
  - `testing.md` (35 lines) - VITEST requirement, TDD default

- **staging/agents/** - 9 specialized agents from hackathon winner
  - security-reviewer.md, code-reviewer.md, build-error-resolver.md
  - tdd-guide.md, e2e-runner.md, refactor-cleaner.md
  - doc-updater.md, planner.md, architect.md

- **staging/hooks/** - Hook scripts for automation
  - `memory-persistence/` - session-start.sh, session-end.sh, pre-compact.sh
  - `strategic-compact/` - suggest-compact.sh

- **staging/contexts/** - 3 context modes
  - dev.md, research.md, review.md

### Changed
- **staging/CLAUDE.md** - Slimmed from 162 to 76 lines
  - Removed content now in modular rules
  - Added META section for self-improvement
  - Added references to rules/, agents/

- **staging/settings.json** - Added hooks configuration
  - PreToolUse: Block --no-verify, suggest compaction
  - PostToolUse: Prettier, tsc check, console.log warning
  - PreCompact: Save state
  - SessionStart: Load previous context
  - Stop: Final console.log audit, persist session

---

## [2026-01-21] - Resource Evaluation Framework

### Added
- **EVALUATE.md** - Structured framework for evaluating Claude Code techniques
  - 9-step evaluation process: Summary, Technical Classification, Hype Check, Fit Assessment, Replacement Analysis, Scoring, Recommendation, Implementation Plan, Caveats
  - Recommendation system: IGNORE, PARK, MICRO-TEST, ADOPT
  - Stack compatibility checks (no serverless, own VPS, Postgres)

- **docs/evaluations/** - Directory for storing full evaluation reports

- **docs/project-claude-template.md** - Template for project-specific CLAUDE.md files

### Changed
- **CLAUDE.md** - Added Resource Evaluation Role section
- **RESEARCH.md** - Added Evaluated Resources tracking table
- **README.md** - Added Resource Evaluation section with usage instructions

---

## Future Changes

### Planned
- [ ] Install Vercel react-best-practices skill
- [ ] Create project-specific skills (ai-sdk, deployment, ops-setup)

### Considerations
- Keep rules under 150 lines combined
- Use hooks for enforcement, not just rules
- Write learnings to dated files, consolidate weekly
- Test all changes before deploying to production
