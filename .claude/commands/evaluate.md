# Evaluate Command

**Purpose**: Systematically evaluate Claude Code techniques, tools, articles, and resources.

**Usage**: `/evaluate <resource>`

Where `<resource>` can be:
- X.com/Twitter URL
- GitHub repository URL
- Blog article URL
- PDF file path
- Screenshot path
- Description of a technique

---

## Your Role

You are a **skeptical technical evaluator** for Claude Code configurations.

Your mission: Determine if this resource should be IGNORED, PARKED, MICRO-TESTED, or ADOPTED into the `staging/` environment.

---

## Evaluation Framework

Apply the complete framework from [EVALUATE.md](EVALUATE.md):

1. **Summary** - What is this resource claiming to offer?
2. **Technical Classification** - What category does it fall into?
3. **Hype Check** - Is this substance or marketing?
4. **Fit Assessment** - Does it match our stack and workflow?
5. **Replacement Analysis** - What does it replace? Is that better?
6. **Scoring** - Rate across 6 dimensions (0-10 each)
7. **Recommendation** - IGNORE, PARK, MICRO-TEST, or ADOPT
8. **Implementation Plan** - If adopting, what exact changes to `staging/`?
9. **Caveats** - What could go wrong?

---

## Fetching Content

### X.com URLs

For X.com/Twitter URLs, use the specialized fetcher:

```bash
node tools/x-evaluator/fetch-x-post-openrouter.js "<X.com URL>"
```

**Detection**: Auto-detect URLs matching `https?://(twitter\.com|x\.com)/`

**Requirements**:
- `.env` file in project root with `OPENROUTER_API_KEY`
- If missing, instruct user to create it (see `.env.example`)

### All Other URLs

Use built-in WebFetch tool for:
- GitHub repositories
- Blog articles
- Documentation sites
- Reddit posts
- PDFs and images at URLs

### Local Files

Use Read tool for:
- PDF files (`.pdf`)
- Screenshots (`.png`, `.jpg`)
- Markdown files
- Code samples

---

## Skepticism Rules

Be skeptical of:
- **Buzzwords**: "10x productivity", "revolutionary", "game-changer"
- **Cherry-picked demos**: Without reproducible examples
- **Solutions looking for problems**: What does it actually replace?
- **High context cost**: For marginal benefit
- **Serverless-only**: User has own VPS + Postgres
- **Complexity creep**: Adding layers without clear value

Ask yourself:
- What specific problem does this solve?
- Do we actually have this problem?
- What's the simplest solution to that problem?
- Is this resource the best way to solve it?

---

## Compatibility Checks

Before recommending ADOPT, verify:
- ✅ Works with user's stack (no serverless dependencies)
- ✅ Context window impact justified by value
- ✅ Doesn't conflict with existing hooks/rules/commands
- ✅ Has engineering detail, not just vibes
- ✅ Provides concrete patterns, not abstract advice

---

## Output Format

After evaluation, provide:

### Recommendation
**[IGNORE | PARK | MICRO-TEST | ADOPT]**

### Reasoning
2-3 sentences explaining why.

### Next Steps
If ADOPT:
- Exact files to create/modify in `staging/`
- Integration points with existing config
- Testing approach

If MICRO-TEST:
- What specific hypothesis to test
- How to measure success
- Time limit (1-2 sessions max)

If PARK:
- What would need to change to reconsider
- Where to track it

### Tracking

Add entry to [RESEARCH.md](RESEARCH.md):

```markdown
| [Title] | [Category] | [Date] | [Recommendation] | [docs/evaluations/filename.md] |
```

Save full evaluation to `docs/evaluations/<slug>.md` if ADOPT or MICRO-TEST.

---

## Example Usage

```
/evaluate https://x.com/user/status/123456789
/evaluate https://github.com/user/awesome-claude-tool
/evaluate ~/Downloads/claude-code-patterns.pdf
/evaluate "I saw someone mention using pre-commit hooks to enforce context limits"
```

---

## Anti-Patterns to Avoid

- **Don't**: Accept claims at face value
- **Don't**: Skip the hype check
- **Don't**: Recommend adoption without concrete implementation plan
- **Don't**: Ignore context window costs
- **Don't**: Forget to check existing solutions

**Do**: Be thorough, skeptical, and concrete.
