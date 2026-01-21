# Research Notes

Links, articles, and analysis notes for Claude Code optimization.

---

## Core Resources

### Official Documentation
- [Claude Code Hooks Guide](https://code.claude.com/docs/en/hooks-guide)
- [Anthropic Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)

### Essential Guides
- [The Shorthand Guide to Everything Claude Code](https://x.com/affaanmustafa/status/2012378465664745795) - Hackathon winner's overview
- [The Longform Guide to Everything Claude Code](https://x.com/affaanmustafa/status/2014040193557471352) - Detailed follow-up
- [Builder.io CLAUDE.md Guide](https://www.builder.io/blog/claude-md-guide) - File placement and structure
- [Claude Skills Deep Dive](https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/) - Skills architecture explained

---

## Self-Improvement

### The Magic Prompt
> "Reflect on this mistake. Abstract and generalize the learning. Write it to CLAUDE.md."

### Resources
- [Self-Improving AI Article](https://dev.to/aviad_rozenhek_cba37e0660/self-improving-ai-one-prompt-that-makes-claude-learn-from-every-mistake-16ek)
- [claude-skill-self-improvement](https://github.com/bokan/claude-skill-self-improvement) - Automated pattern extraction

### Key Insight
Write learnings to dated files (`~/.claude/learned/2026-01-21.md`) not directly to CLAUDE.md. Consolidate weekly to prevent bloat.

---

## Community Resources

### Curated Collections
- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) - Community resource catalog
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code) - Hackathon winner configs (in reference/)

### Skills & Plugins
- [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) - React best practices, web design guidelines
- [Trail of Bits Security Skills](https://github.com/trailofbits/skills) - Professional security auditing
- [Context Engineering Kit](https://github.com/NeoLabHQ/context-engineering-kit) - Minimal token footprint

### Hooks
- [TDD Guard](https://github.com/nizos/tdd-guard) - Real-time TDD enforcement
- [TypeScript Quality Hooks](https://github.com/bartolli/claude-code-typescript-hooks) - Compilation + formatting
- [CC Notify](https://github.com/dazuiba/CCNotify) - Desktop notifications

### Workflows
- [RIPER Workflow](https://github.com/tony/claude-code-riper-5) - Research → Innovate → Plan → Execute → Review
- [Claude CodePro](https://github.com/maxritter/claude-codepro) - Spec-driven + TDD
- [AB Method](https://github.com/ayoubaben18/ab-method) - Large problems → focused missions

### Orchestrators
- [Claude Squad](https://github.com/smtg-ai/claude-squad) - Multiple agents in git worktrees
- [Claude Swarm](https://github.com/parruda/claude-swarm) - Agent swarm coordination
- [Happy Coder](https://github.com/slopus/happy) - Control multiple Claudes from phone

---

## Patterns & Best Practices

### Claude Bootstrap Patterns
From [alinaqi/claude-bootstrap](https://github.com/alinaqi/claude-bootstrap):

**Hard Limits**:
- 20 lines per function maximum
- 3 parameters maximum per function
- 2-level nesting depth maximum
- 200 lines per file maximum
- 80% test coverage minimum

**Commit Hygiene**:
| State | Files | Lines | Action |
|-------|-------|-------|--------|
| Green | ≤5 | ≤200 | Optimal |
| Yellow | 6-10 | 201-400 | Commit soon |
| Red | >10 | >400 | Commit NOW |

### Claude Code Showcase
From [ChrisWiles/claude-code-showcase](https://github.com/ChrisWiles/claude-code-showcase):

**Hook Response Format**:
```json
{
  "block": true,
  "message": "reason",
  "feedback": "info",
  "suppressOutput": true,
  "continue": false
}
```

**Exit Codes**:
- 0: Success
- 2: Blocking error (PreToolUse only)

---

## Context Management

### Quality Degradation Map
| Context % | Quality | Recommendation |
|-----------|---------|----------------|
| 0-40% | Excellent | Optimal zone |
| 40-60% | Good | Still effective |
| 60-80% | Degrading | Start being selective |
| 80-95% | Poor | Manual compaction needed |
| 95-100% | Critical | "The last 20% is poison" |

### MCP Guidelines
- Keep under 10 MCPs enabled per project
- Max ~80 active tools
- Use `disabledMcpServers` in project config

---

## Verified Patterns (From Mistakes)

| Mistake | Lesson |
|---------|--------|
| Converted tests to bun:test | ALWAYS use VITEST |
| Used --no-verify | NEVER skip pre-commit hooks |
| AI SDK v5 patterns | We use AI SDK v6 |
| Added newlines to env vars | Use `echo -n` |
| .js extensions in imports | Turbopack hates them |
| Blamed pre-existing errors | Fix ALL errors you see |
| Auto-refunded purchases | Platform never auto-refunds |
| Skipped DATABASE_URL at build | Required at build time |
| Singleton imports in serverless | Use lazy initialization |
| Direct drizzle-orm imports | Import from @/core/db |
| npm in Vercel | Use bun |
| Assumed shared root .env | Each app needs own .env |

---

## To Investigate

- [ ] Trail of Bits security skills implementation
- [ ] Vercel react-best-practices installation
- [ ] TDD Guard hook integration
- [ ] Strategic compact patterns
- [ ] Claude SDK agent patterns

---

## Notes

*Add your own notes and findings here as you experiment.*
