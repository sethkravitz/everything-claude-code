# Claude Code Configuration Lab

**Your staging environment for Claude Code configuration development.**

This repository is a testing ground for Claude Code configs before deploying to production `~/.claude/`. Experiment safely, track changes, and deploy with confidence.

---

## Repository Structure

```
everything-claude-code/
├── staging/                     # MIRROR of ~/.claude/ for testing
│   ├── CLAUDE.md               # Global instructions
│   ├── settings.json           # Hooks, permissions, plugins
│   ├── agents/                 # Specialized subagents
│   ├── commands/               # Slash commands
│   ├── skills/                 # Domain knowledge
│   ├── rules/                  # Always-loaded rules
│   ├── hooks/                  # Hook scripts
│   ├── contexts/               # Mode toggles
│   ├── learned/                # Self-improvement archive
│   └── bin/                    # Utility scripts
│
├── tools/                       # Project-specific utilities
│   └── x-evaluator/            # X.com post fetcher for evaluations
│
├── reference/                   # External resources for study
│   └── hackathon-winner/       # Original everything-claude-code configs
│
├── scripts/
│   ├── backup.sh               # Backup current ~/.claude/
│   ├── deploy.sh               # Copy staging/ to ~/.claude/
│   ├── diff.sh                 # Compare staging vs production
│   └── consolidate-learnings.sh # Weekly learnings review
│
├── docs/
│   ├── architecture.md          # How everything fits together
│   ├── decision-tree.md         # When to use what
│   └── troubleshooting.md       # Common issues and fixes
│
├── RESEARCH.md                  # Links, articles, analysis notes
└── CHANGELOG.md                 # What changed and when
```

---

## Quick Start

### 1. View current differences

```bash
./scripts/diff.sh
```

### 2. Make changes in staging/

Edit files in `staging/` to test new configurations.

### 3. Backup and deploy

```bash
./scripts/backup.sh      # Always backup first
./scripts/deploy.sh      # Deploy to ~/.claude/
```

### 4. Test in a new session

Start a fresh Claude Code session to test your changes.

---

## Current Configuration

### Commands (8)
| Command | Purpose |
|---------|---------|
| `/autonomous` | 10-phase planned feature work |
| `/careful` | Step-by-step with approval gates |
| `/spike` | 90-min rapid validation (TDD suspended) |
| `/review` | Code audit (quick or `--ship` formal) |
| `/brief` | Create Grade A briefs from vague ideas |
| `/evolve` | Skeptical resource evaluation |
| `/evaluate` | **[Project-only]** Evaluate Claude Code resources |
| `/end` | Clean session closeout |

### Skills (1)
- `coding-standards` - Language best practices

### Key Features
- **Verification mindset** - "Your confidence is NOT evidence"
- **Brief grading** - A/B/C classification before work
- **Hard stops** - No TODOs, console.log, placeholders, dead code
- **Safety rules** - Trash system, no rm -rf, no force push

---

## Workflow

```
1. RESEARCH      - Explore patterns in reference/ and docs/
       ↓
2. EXPERIMENT    - Make changes in staging/
       ↓
3. COMPARE       - ./scripts/diff.sh
       ↓
4. BACKUP        - ./scripts/backup.sh
       ↓
5. DEPLOY        - ./scripts/deploy.sh
       ↓
6. TEST          - New Claude Code session
       ↓
7. ITERATE       - Refine based on results
```

---

## Self-Improvement System

When Claude makes a mistake:

```
"Reflect on this mistake. Write to ~/.claude/learned/$(date +%Y-%m-%d).md"
```

Weekly consolidation:
```bash
./scripts/consolidate-learnings.sh
```

This promotes frequent patterns to permanent rules while archiving one-offs.

---

## Resource Evaluation

This repo also serves as a **research and evaluation hub** for Claude Code techniques.

When you find a new article, repo, tool, or technique, use the project-specific command:

```
/evaluate <URL | file path | description>
```

**Examples**:
```
/evaluate https://x.com/user/status/123456789
/evaluate https://github.com/user/awesome-claude-tool
/evaluate ~/Downloads/claude-patterns.pdf
/evaluate "Using pre-commit hooks to enforce context limits"
```

Claude will:
1. Fetch/read the resource (auto-detects X.com URLs and uses specialized fetcher)
2. Apply the [EVALUATE.md](EVALUATE.md) framework
3. Make a clear recommendation: **IGNORE**, **PARK**, **MICRO-TEST**, or **ADOPT**
4. If ADOPT: Propose exact changes to `staging/`

Evaluations are tracked in [RESEARCH.md](RESEARCH.md) and stored in `docs/evaluations/`.

---

## Tools

### X.com Evaluator

Project-specific tool for fetching X.com post content during resource evaluation.

**Why**: X.com blocks standard web scrapers. This tool uses Grok (xAI's LLM) via OpenRouter API to bypass bot detection.

**Location**: `tools/x-evaluator/`

**Setup**:
Create a `.env` file in the project root:
```bash
OPENROUTER_API_KEY="sk-or-v1-..."  # Get from https://openrouter.ai/keys
```

See `.env.example` for template.

**Note**: Scripts run without approval prompts (pre-authorized in `.claude/settings.json`).

**Usage**:

Automatic routing (recommended):
```bash
./tools/x-evaluator/evaluate.sh "<URL>"
```

Direct fetch for X.com URLs:
```bash
node tools/x-evaluator/fetch-x-post-openrouter.js "<X.com URL>"
```

**How it works**:
- `evaluate.sh` detects X.com URLs and routes to the OpenRouter fetcher
- Non-X.com URLs return a message to use Claude's WebFetch tool
- Extracts complete post content: author, timestamp, text, threads, media

**Integration**:
See [EVALUATE.md](EVALUATE.md) for how this fits into the evaluation workflow.

---

## Documentation

| Document | Purpose |
|----------|---------|
| [EVALUATE.md](EVALUATE.md) | Resource evaluation framework |
| [docs/architecture.md](docs/architecture.md) | How components work together |
| [docs/decision-tree.md](docs/decision-tree.md) | When to use what |
| [docs/troubleshooting.md](docs/troubleshooting.md) | Common issues and fixes |
| [RESEARCH.md](RESEARCH.md) | Links and analysis notes |
| [CHANGELOG.md](CHANGELOG.md) | Configuration history |

---

## Reference Materials

The `reference/hackathon-winner/` directory contains the original [everything-claude-code](https://github.com/affaan-m/everything-claude-code) configs from Anthropic hackathon winner [@affaanmustafa](https://x.com/affaanmustafa). These serve as inspiration and patterns to adapt.

Includes:
- 9 specialized agents
- 10+ skills
- 18 hooks
- 8 modular rules
- Context modes

See the original guide: [The Shorthand Guide to Everything Claude Code](https://x.com/affaanmustafa/status/2012378465664745795)

---

## Context Budget Guidelines

| Component | When Loaded | Context Cost |
|-----------|-------------|--------------|
| CLAUDE.md | Session start | Heavy |
| Rules | Session start | Heavy |
| MCP tools | Session start | Medium |
| Skill descriptions | Session start | Light |
| Commands | On invoke | Heavy |
| Agents | On spawn | Zero (isolated) |
| Hooks | Never | Zero |

**Keep CLAUDE.md + rules under 150 lines combined.**

---

## Scripts

| Script | Purpose |
|--------|---------|
| `backup.sh` | Create timestamped backup of ~/.claude/ |
| `deploy.sh` | Copy staging/ to ~/.claude/ |
| `diff.sh` | Compare staging vs production |
| `consolidate-learnings.sh` | Review and promote learned patterns |

---

## License

MIT
