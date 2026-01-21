# Evolve Command

**Purpose**: Analyze external AI/Claude resources with rigorous skepticism and evolve our setup based on findings. Works standalone or mid-session.

---

## Two Modes

### Mode 1: Analyze Resource
```
/evolve [URL or "analyze:" followed by pasted text]
```

### Mode 2: Update Setup
```
/evolve update: [what to change]
```

---

## MODE 1: RESOURCE ANALYSIS

### Step 1: Fetch and Parse

Retrieve the content from URL or parse pasted text.

### Step 2: Summary of the Claim

Explain what they're actually claiming in 2-5 bullets:
- The promised technique or method
- The problem it claims to solve
- The stated or implied outcome

### Step 3: Technical Reality Check

Translate into plain technical terms. Classify as:

| Type | Description |
|------|-------------|
| Prompting pattern | System prompts, few-shot, chain-of-thought |
| Memory architecture | Context persistence, RAG, embeddings |
| Multi-agent workflow | Coordination, parallel work, handoffs |
| Orchestration tool | Loops, state machines, workflow engines |
| MCP/Tool pattern | Tool design, MCP servers, integrations |
| Evaluation method | Quality checks, benchmarks, verification |
| UX pattern | Interface, interaction design |
| Infrastructure | Scaling, caching, optimization |
| Misrepresentation | "Just ChatGPT with extra steps" |

### Step 4: Hype / Credibility Check

Be skeptical. Evaluate:

| Check | Question |
|-------|----------|
| Evidence | Repo? Demo? Benchmarks? Architecture diagrams? |
| Specificity | Measurable outcomes or vibes? |
| Terminology | Correct use or buzzword salad? |
| Cherry-picking | Suspicious numbers? Best-case only? |
| Overclaiming | Does the demo match the promise? |
| Engineering detail | Could you actually build this from what's shown? |
| Simplicity test | Is this "just X with extra steps"? |

**Call out red flags directly. No diplomacy.**

### Step 5: Fit Mapping

Map to our Claude Code setup categories:

| Category | What It Covers | Current State |
|----------|----------------|---------------|
| **Context/Memory** | Surviving compaction, session persistence | working-context.md, context-anchor.json |
| **Workflow/Modes** | Autonomous work, checkpoints, phases | /autonomous, /careful, /prototype |
| **Quality/Oversight** | Catching mistakes, verification | /review, /audit commands |
| **Efficiency** | Token usage, speed, parallelism | Pattern-based permissions |
| **Skills/Prompting** | How Claude approaches problems | coding-standards skill |
| **Tools/MCP** | External integrations | Plugins, MCP servers |

**Fit Score (1-5) for each relevant category.**

### Step 6: What This Replaces

State explicitly what existing workflow, file, or pattern this would displace.

**If nothing is meaningfully replaced, that's a red flag.**

### Step 7: Scores

| Score | Rating (1-5) | Rationale |
|-------|--------------|-----------|
| Usefulness | | Does it solve a real problem we have? |
| Effort | | How hard to implement? |
| Time to Signal | | How fast can we know if it works? |
| Bullshit Risk | | Likelihood this is overhyped garbage |
| Fit | | Alignment with our setup and goals |

### Step 8: Priority Tag

| Tag | Meaning |
|-----|---------|
| **Critical** | Solves active pain point, implement now |
| **High** | Clear value, schedule soon |
| **Medium** | Worth trying when bandwidth allows |
| **Low** | Interesting but not urgent |
| **Ignore** | Not useful or too much hype |

### Step 9: Recommendation

Choose one:

| Verdict | Meaning |
|---------|---------|
| **IGNORE** | Not worth attention |
| **PARK IT** | Save reference, revisit later |
| **MICRO-TEST** | ≤2 hours to validate core idea |
| **IMPLEMENT** | Worth building into our setup |

Explain in 2-4 bullets why.

### Step 10: Proposed Implementation (If Applicable)

For MICRO-TEST or IMPLEMENT:

```
**Implementation Plan**

Goal: [What we're trying to achieve]

Files to modify:
- [file]: [what changes]

Steps:
1. [Step]
2. [Step]

Effort: [X minutes/hours]

Success signal: [How we know it worked]
```

### Step 11: What's Missing / Caveats

Call out:
- Missing details that would enable better evaluation
- Assumptions we're making
- Risks if we implement

---

## Output Format

```
## Evolve Analysis: [Source/Title]

### Claim Summary
- [Bullet 1]
- [Bullet 2]

### Technical Reality
**Type:** [Category from table]
**What they're actually doing:** [Plain description]

### Hype Check
**Evidence:** [Strong/Medium/Weak] — [Details]
**Red Flags:** [List or "None"]
**Simplicity Test:** [Is this just X with extra steps?]

### Fit Mapping
| Category | Fit (1-5) | Notes |
|----------|-----------|-------|
| [Cat] | [Score] | [Why] |

### What It Replaces
[Current thing] → [Proposed thing]
Or: "Nothing meaningful — red flag"

### Scores
| Metric | Score | Rationale |
|--------|-------|-----------|
| Usefulness | X/5 | [Why] |
| Effort | X/5 | [Why] |
| Time to Signal | X/5 | [Why] |
| Bullshit Risk | X/5 | [Why] |
| Fit | X/5 | [Why] |

### Priority: [TAG]

### Recommendation: [VERDICT]
- [Reason 1]
- [Reason 2]

### Implementation (if applicable)
[Plan from Step 10]

### Caveats
- [Caveat 1]
- [Caveat 2]

---
**Options:**
1. Implement now
2. Park it (save to backlog)
3. Skip
4. Discuss further
```

---

## MODE 2: UPDATE SETUP

When invoked with "update:":

### Step 1: Parse the Request

Understand:
- What's the pain point or desired change?
- Which file(s) need modification?
- Is this a formatting issue, logic issue, or missing feature?

### Step 2: Locate the File

| Changing... | Location |
|-------------|----------|
| Global rules | `~/.claude/CLAUDE.md` |
| Global skill | `~/.claude/skills/[name]/SKILL.md` |
| Global command | `~/.claude/commands/[name].md` |
| Project rules | `[project]/CLAUDE.md` |
| Project skill | `[project]/.claude/skills/[name]/SKILL.md` |
| Project command | `[project]/.claude/commands/[name].md` |
| Permissions | `[project]/.claude/settings.local.json` |

### Step 3: Read and Propose

```
## Proposed Update

**File:** [path]
**Pain point:** [what's wrong]

**Current:**
```
[relevant section]
```

**Proposed:**
```
[updated section]
```

**Why this helps:** [explanation]

---
Apply? [yes/no/modify]
```

### Step 4: Apply

If approved:
1. Use Edit tool (surgical change, not full rewrite)
2. Confirm the change was made
3. If significant, note in working-context.md

---

## Quick Update Examples

```
/evolve update: autonomous checkpoints are too verbose, make them 5 lines max
/evolve update: add permission for gh cli commands
/evolve update: the audit command should have a "quick" mode
/evolve update: mybrain-patterns skill is missing the authenticatedFetch pattern
```

---

## Backlog

Parked items go in working-context.md:

```
### Evolve Backlog

| Date | Source | Type | Priority | Notes |
|------|--------|------|----------|-------|
| 2026-01-07 | [link] | Memory | Medium | Test context persistence idea |
```

---

## Principles

1. **Never be impressed** — Filter signal from noise
2. **No enthusiasm markers** — Direct, structured, skeptical
3. **Red flags called out directly** — No diplomacy
4. **Everything maps to our setup** — Or it's not relevant
5. **Concrete next actions** — Or it's just noise
6. **Surgical updates** — Edit tool, never full rewrites
