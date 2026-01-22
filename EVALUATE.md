# Claude Code Resource Evaluation Framework

When evaluating new Claude Code techniques, articles, repos, or tools, follow this structured process.

---

## 1. Summary of Claim (2-5 bullets)

- What is the person claiming?
- What problem does it solve?
- What's the stated outcome?

---

## 2. Technical Reality Check

Classify what it actually is:

| Category | Examples |
|----------|----------|
| **Hook pattern** | PreToolUse, PostToolUse, Stop automation |
| **Agent configuration** | Specialized subagent with constrained tools |
| **Skill/prompt injection** | Domain knowledge loaded on-demand |
| **Rule/constraint** | Always-loaded behavioral directive |
| **MCP integration** | External tool/API connection |
| **Workflow/orchestration** | Multi-step command like /autonomous |
| **Context management** | Compaction, memory persistence |
| **Prompting pattern** | System prompt technique |
| **Infrastructure** | CLI config, settings.json tweaks |
| **Just hype** | Marketing wrapper on basic functionality |

**What is it actually doing under the hood?**

---

## 3. Hype / Credibility Check

Be skeptical. Evaluate:

| Check | Questions |
|-------|-----------|
| **Evidence** | Is there a repo? Demo? Reproducible example? |
| **Specificity** | Measurable outcomes or just vibes? |
| **Terminology** | Using terms correctly or buzzword salad? |
| **Cherry-picking** | Showing best case only? |
| **Overclaiming** | "10x productivity" without proof? |
| **Engineering detail** | Can you actually see how it works? |
| **Just ChatGPT with extra steps?** | Is this actually novel? |

**Red flags found:**

---

## 4. Claude Code Fit Assessment

### Context Window Impact
- How many tokens does this add to session start?
- Does it load always or on-demand?
- Will it compete with project CLAUDE.md for space?

### Latency Impact
- Does it add hooks that run on every tool use?
- How much delay per operation?

### Security Considerations
- Does it require new permissions?
- Does it touch sensitive data?
- Does it phone home to external services?

### Compatibility
- Works with your stack? (No serverless, own VPS, Postgres)
- Conflicts with existing config?
- Requires dependencies you don't have?

---

## 5. What This Replaces

**Explicitly state what existing workflow, tool, or config this displaces.**

If nothing is meaningfully replaced → RED FLAG.

| Replaces | With |
|----------|------|
| [current thing] | [new thing] |

---

## 6. Scores (1-5)

| Metric | Score | Rationale |
|--------|-------|-----------|
| **Usefulness** | /5 | |
| **Effort to implement** | /5 | (lower = easier) |
| **Time to first signal** | /5 | (lower = faster) |
| **Bullshit risk** | /5 | (lower = more legit) |
| **Context cost** | /5 | (lower = leaner) |

---

## 7. Recommendation

Choose one:

| Decision | Meaning |
|----------|---------|
| **IGNORE** | Not useful, too much hype, doesn't fit |
| **PARK** | Interesting but not now, save to RESEARCH.md |
| **MICRO-TEST** | ≤2 hours to try in staging/ |
| **ADOPT** | Add to staging/, test, deploy |

---

## 8. Implementation Plan (if MICRO-TEST or ADOPT)

### What to add
- [ ] File(s) to create in staging/
- [ ] Changes to settings.json
- [ ] Dependencies or scripts needed

### Test plan
- How to verify it works
- What success looks like
- Rollback if it fails

### Where it goes
- `staging/agents/` ?
- `staging/skills/` ?
- `staging/hooks/` ?
- `staging/rules/` ?

---

## 9. Caveats / Missing Info

What would you need to see to make a better decision?

---

## Template Usage

When someone brings a link:

```
Evaluate this for our Claude Code setup: [URL]
```

Claude should:
1. Fetch/read the resource
2. Fill out this framework
3. Make a clear recommendation
4. If ADOPT: propose exact changes to staging/

---

## Fetching Content

### X.com (Twitter) URLs

X.com blocks standard web scraping. Use the specialized fetcher:

```bash
node tools/x-evaluator/fetch-x-post-openrouter.js "<X.com URL>"
```

**Requirements:**
- Create `.env` file in project root with: `OPENROUTER_API_KEY="sk-or-v1-..."`
- Get key from: https://openrouter.ai/keys
- See `.env.example` for template

### All Other URLs

Use built-in WebFetch tool:
- Articles (blogs, documentation)
- GitHub repos
- Reddit posts
- PDFs, images

**Example:**
```
Evaluate this: https://github.com/user/repo
```
Claude will fetch automatically.
