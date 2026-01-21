# Review (Code Audit)

**Purpose:** Challenge the code. Find bugs, logic errors, security issues. Don't trust that it works just because it compiles.

---

## Two Modes

| Mode | When to Use | Output |
|------|-------------|--------|
| `/review` | Quick issue-finding | Issues listed by severity |
| `/review --ship` | Before shipping/merging | PASS/FAIL verdict with evidence |

---

## Mindset

**Assume nothing works.** Prove it does.

- Compiling ≠ working
- Tests passing ≠ correct
- "Looks fine" ≠ verified
- Your confidence is NOT evidence

---

## What to Check

### 1. Logic Errors
- Off-by-one errors
- Null/undefined handling
- Edge cases (empty arrays, zero values, negative numbers)
- Race conditions in async code
- State mutations where immutability expected

### 2. Security Issues
- SQL injection (parameterized queries?)
- XSS (user input escaped?)
- Command injection (shell commands with user input?)
- Secrets in code (API keys, passwords?)
- Authentication bypasses
- Authorization checks missing

### 3. Code Quality
- Dead code (unused functions, unreachable branches)
- Unused variables
- Duplicate logic that should be extracted
- Functions doing too many things
- Error handling that swallows errors silently

### 4. Type Safety
- Any use of the "any" type
- Type assertions (as keyword) hiding real issues
- Non-null assertions (! operator) on potentially null values
- Generic types that are too loose

### 5. Test Coverage
- Are the important paths tested?
- Are edge cases tested?
- Are error paths tested?
- Tests actually assert something meaningful?

---

## Process

### Step 1: Identify Scope
"What code should I review?"
- Specific files?
- Recent changes (git diff)?
- Entire feature/module?

### Step 2: Read the Code
Actually read it. Line by line. Don't skim.

### Step 3: Challenge Every Assumption
For each function/block:
- What happens if inputs are null?
- What happens if inputs are empty?
- What happens if this fails?
- What happens under concurrent access?
- What happens with malicious input?

### Step 4: Verify Claims
If code claims to do X, verify it actually does X:
- Trace the execution path
- Check all callers
- Grep for edge cases

### Step 5: Report Findings

```
## Review: [Scope]

### Critical Issues (Must Fix)
- **[File:Line]** [Description]
  - Why it's critical: [impact]
  - Fix: [suggested fix]

### Important Issues (Should Fix)
- **[File:Line]** [Description]
  - Fix: [suggested fix]

### Minor Issues (Nice to Fix)
- **[File:Line]** [Description]

### Verified Correct
- [What was checked and found to be correct]

### Not Reviewed
- [What was out of scope or not checked]
```

---

## Red Flags to Hunt

```typescript
// DANGEROUS: Type assertion hiding issues
const data = response as UserData;

// DANGEROUS: Non-null assertion
const user = getUser()!;

// DANGEROUS: Swallowing errors
try { ... } catch (e) { /* ignore */ }

// DANGEROUS: String concatenation for SQL/commands
query(`SELECT * FROM users WHERE id = ${userId}`);

// DANGEROUS: Any type
function process(data: any) { ... }

// SUSPICIOUS: Magic numbers
if (retries > 3) { ... }

// SUSPICIOUS: Comments explaining what code does
// (code should be self-explanatory)
```

---

## --ship Mode (Formal Quality Gate)

Use --ship when you need a formal PASS/FAIL verdict before shipping.

### The Three Filters

#### FILTER 1: Deep Thought (Fight Laziness)

**Logic Check:**
- Did we settle for the first solution that "worked," or find the BEST solution?
- Is this approach robust, or just the path of least resistance?
- Would a senior engineer approve this code?

**Assumption Check:**
- Are we assuming "Happy Path" only?
- Simulate the "Worst Case" - does the logic hold?
  - What if input is null, undefined, empty?
  - What if network fails?
  - What if data is malformed?
  - What if there are race conditions?

**Quality Score:** Rate 1-10 (6 = mediocre, 8 = solid, 10 = exemplary)

#### FILTER 2: Minimalist (Fight Bloat)

**Code Volume:**
- Is this the minimum code needed?
- Could this be simpler while achieving the same result?
- Are there unnecessary abstractions?

**Scope Discipline:**
- Was anything built that wasn't explicitly requested?
- Are there "helpful extras" that weren't approved?
- Did scope creep occur?

**Dependency Diet:**
- Were new dependencies added?
- Could any be replaced with 10 lines of native code?

#### FILTER 3: Production Reality (Fight Fragility)

**Hygiene:**
- No TODOs, no placeholders, no dead code
- Secrets via env vars only
- No debugging code left behind
- No commented-out code

**Stability:**
- Versions pinned explicitly
- Compiles clean (npx tsc --noEmit)
- Lints clean (npm run lint)
- Tests pass (if applicable)

**Completeness:**
- All callers updated if signatures changed
- All references removed if files deleted
- Error handling in place
- Edge cases handled

### Evidence Requirements

For every claim, demand proof:

| Claim | Required Evidence |
|-------|-------------------|
| "It works" | Show it working or test output |
| "I tested it" | Show test output |
| "I fixed X" | Show the before/after diff |
| "Tests pass" | Show npm test output |
| "Lint is clean" | Show npm run lint output |

If no evidence exists, mark as **UNVERIFIED**.

### --ship Output Format

```
## Ship Review: [Scope]

### Files Audited
- [file1] — [what was changed]
- [file2] — [what was changed]

### Filter 1: Deep Thought
- Logic: [Pass/Fail] — [notes]
- Assumptions: [Pass/Fail] — [edge cases found]
- Quality Score: [X/10]

### Filter 2: Minimalist
- Code Volume: [Pass/Fail] — [could be simpler?]
- Scope: [Pass/Fail] — [scope creep detected?]
- Dependencies: [Pass/Fail] — [unnecessary deps?]

### Filter 3: Production
- Hygiene: [Pass/Fail] — [TODOs, dead code?]
- Stability: [Pass/Fail] — [build results]
- Completeness: [Pass/Fail] — [missing pieces?]

### Verified Claims
- [x] [Claim] — Evidence: [proof]
- [ ] [Claim] — UNVERIFIED

### Issues Found
1. [Issue] — Severity: [High/Medium/Low]

### Verdict
[PASS / PASS WITH WARNINGS / FAIL]

### Required Actions
1. [Action needed before shipping]

Or: "No issues found. Ready to ship."
```

---

## After Review

If issues found:
1. Ask: "Should I fix these now?"
2. If yes, fix them one by one
3. Re-run review on fixes to verify

If no issues found:
- State what was verified
- Acknowledge what wasn't checked

---

## For MyBrain-Specific Review

Use `/review-mybrain` instead - it includes project-specific checks (import boundaries, tool patterns, etc.)
