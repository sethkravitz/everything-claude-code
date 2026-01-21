# Decision Tree: When to Use What

Quick reference for choosing the right Claude Code mode, command, or agent.

## Main Decision Tree

```
What are you doing?
│
├─ NEW FEATURE (planned work)
│   ├─ High risk (auth, payments, unfamiliar) → /careful
│   └─ Normal risk → /autonomous
│
├─ QUICK VALIDATION (testing an idea)
│   └─ → /spike (TDD suspended, 90-min timebox)
│
├─ CODE REVIEW
│   ├─ Quick scan → /review
│   └─ Formal gate → /review --ship
│
├─ CREATING A BRIEF
│   └─ → /brief (9-phase interview)
│
├─ EVALUATING EXTERNAL RESOURCE
│   └─ → /evolve (skeptical analysis)
│
├─ NEED SPECIALIZED HELP
│   ├─ Security concern → spawn security-reviewer agent
│   ├─ Build broken → spawn build-error-resolver agent
│   ├─ Writing tests → spawn tdd-guide agent
│   ├─ E2E tests → spawn e2e-runner agent
│   ├─ Architecture question → spawn architect agent
│   ├─ Code quality → spawn code-reviewer agent
│   ├─ Dead code cleanup → spawn refactor-cleaner agent
│   └─ Documentation → spawn doc-updater agent
│
├─ WANT CLAUDE TO LOOP UNTIL DONE
│   └─ → /ralph-loop (Stop hook catches completion)
│
├─ EXPLORING CODEBASE
│   └─ → Spawn Explore agent (saves YOUR context)
│
├─ ENDING SESSION
│   └─ → /end (clean closeout)
│
└─ JUST CODING NORMALLY
    └─ Default mode. Skills auto-activate as needed.
```

## Command Quick Reference

| Command | When to Use | Key Feature |
|---------|-------------|-------------|
| `/autonomous` | Planned features, phased work | 10-phase workflow with parallel agents |
| `/careful` | Sensitive code, unfamiliar territory | Step-by-step approval gates |
| `/spike` | Quick validation, prototypes | TDD suspended, 90-min timebox |
| `/review` | Code audit | Quick scan or formal gate |
| `/brief` | Vague requirements | 9-phase interview, Grade A output |
| `/evolve` | External resources | Skeptical evaluation, hype detection |
| `/end` | Session cleanup | Handoff summary |

## Agent Quick Reference

| Agent | When to Spawn | What It Does |
|-------|---------------|--------------|
| `security-reviewer` | Security concerns | Vulnerability analysis |
| `code-reviewer` | Code quality check | Focused quality review |
| `build-error-resolver` | Build failures | Systematic debugging |
| `tdd-guide` | Writing tests | Test-first methodology |
| `e2e-runner` | E2E testing | Playwright automation |
| `architect` | Design decisions | System design guidance |
| `refactor-cleaner` | Dead code | Cleanup methodology |
| `doc-updater` | Documentation | Doc sync and maintenance |
| `planner` | Feature planning | Complements /brief |

## Context Modes

| Mode | When to Use | Behavior |
|------|-------------|----------|
| `dev` | Active coding | Write code first, explain after |
| `research` | Investigation | Analyze thoroughly, no code yet |
| `review` | Auditing | Security-first, detailed feedback |

## TDD Decision

```
Should I use TDD?
│
├─ Using /spike?
│   └─ NO - TDD suspended for speed
│
├─ Bug fix?
│   └─ YES - Write failing test first
│
├─ New feature?
│   └─ YES - Tests drive implementation
│
└─ Refactoring?
    └─ YES - Tests ensure no regression
```

## Brief Grading

Before starting any work:

| Grade | Characteristics | Action |
|-------|-----------------|--------|
| **A** | Clear outcomes, explicit boundaries | Proceed |
| **B** | Mostly clear, 1-2 ambiguities | Ask 2-3 questions, then proceed |
| **C** | Unclear outcomes, multiple ambiguities | STOP. Ask 4-6 questions first. |
