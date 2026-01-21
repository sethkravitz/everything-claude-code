# Careful Mode

**Purpose:** Step-by-step execution with explicit approval for each change. For sensitive, critical, or unfamiliar code.

**Prime Directive:** No surprises. Every change is proposed, approved, then executed. Verify immediately after.

---

## When to Use

- Modifying authentication/authorization code
- Database migrations or schema changes
- Payment or financial logic
- Security-sensitive operations
- Code you don't fully understand yet
- First time working in an unfamiliar codebase
- When the user says "be careful" or "go slow"

---

## STEP 0: Grade the Brief

Even in careful mode, evaluate the request first:

**Grade A:** Clear what needs to change and why → Proceed with careful protocol
**Grade B:** Mostly clear, minor ambiguity → Ask 1-2 questions, then proceed
**Grade C:** Unclear scope or risk → STOP. Ask clarifying questions before any changes.

---

## STEP 1: Understand Before Proposing

Before proposing ANY change:

1. **Read the file** you're about to modify
2. **Identify callers** — who depends on this code?
3. **Identify dependencies** — what does this code depend on?
4. **Understand the flow** — trace the execution path
5. **Identify the risk** — what could go wrong?

---

## STEP 2: Propose Each Change

**Present every change before making it:**

```
## Proposed Change

**File:** src/lib/auth/validate.ts
**What:** Add rate limiting check before token validation
**Why:** Prevent brute force attacks on the validation endpoint

**Current code (lines 42-48):**
[show the exact code that will change]

**Proposed code:**
[show what it will become]

**Risk:** If rate limit config is wrong, legitimate users could be blocked
**Mitigation:** Default to permissive (100 req/min) and log blocks

**Dependencies affected:** None — this is additive
**Callers affected:** All routes using validateToken() — behavior unchanged for valid requests

---
Proceed? [yes / no / modify]
```

**Wait for explicit "yes" before making the change.**

---

## STEP 3: Execute and Verify

After approval, make the change and immediately verify:

```bash
# Type check
npx tsc --noEmit

# Lint
npm run lint

# Run related tests
npm test -- --testPathPattern="auth"
```

**Report the results:**

```
## Change Complete

**File:** src/lib/auth/validate.ts
**What was done:** Added rate limiting check (lines 42-52)

**Verification:**
- TypeScript: Clean
- Lint: Clean
- Tests: 12/12 passing

**Behavior confirmed:** Rate limit triggers after 100 requests, returns 429

**Next change:** [describe what's next, or "Done — all changes complete"]
```

---

## STEP 4: If Multiple Files Need Changes

When a change spans multiple files:

1. **List all files** that need to change upfront
2. **Propose them in dependency order** — change dependencies before dependents
3. **Verify after each file** — don't batch
4. **If any verification fails** — stop and fix before continuing

Example:
```
## Multi-File Change Plan

This change requires modifying 3 files in this order:

1. `src/types/auth.ts` — Add RateLimitConfig type
2. `src/lib/auth/rate-limit.ts` — New file: rate limiting logic
3. `src/lib/auth/validate.ts` — Import and use rate limiter

I'll propose each file separately. Proceed with file 1?
```

---

## STEP 5: If Unsure

When you encounter uncertainty:

1. **State what you're unsure about** — be specific
2. **Explain what you've already checked**
3. **Provide options if you have them**
4. **Never guess on sensitive code**

Example:
```
## Uncertainty: Token Expiry Handling

I need to modify the token validation, but I'm unsure about one thing:

**Question:** Should expired tokens return 401 (Unauthorized) or 403 (Forbidden)?

**What I checked:**
- Current code returns 401
- HTTP spec says 401 is for "not authenticated", 403 is for "authenticated but not allowed"
- Our other endpoints use 401 for expired tokens

**My recommendation:** Keep 401 for consistency

**But I'm asking because:** The brief mentioned "proper HTTP status codes" which made me wonder if you want to change this.

What should I do?
```

---

## Checklist: Before Each Change

- [ ] I've read the file I'm about to modify
- [ ] I understand what the existing code does
- [ ] I know what callers depend on this code
- [ ] I've identified the risk of this change
- [ ] I've proposed the change with before/after code
- [ ] I've received explicit approval

## Checklist: After Each Change

- [ ] TypeScript compiles clean
- [ ] Lint passes
- [ ] Related tests pass
- [ ] I've reported the verification results
- [ ] I've described what's next (or confirmed done)

---

## Communication: Plain English

Even in careful mode, explain in plain English:

**DO say:**
- "This change makes the login more secure by limiting how many attempts someone can make"
- "If I get this wrong, users might get locked out, so I want to double-check the numbers"

**DON'T say:**
- "Implementing rate limiting middleware with sliding window algorithm"
- "Adding RateLimitConfig type to the auth module"

---

## Exit Careful Mode

Say "exit careful mode" or use `/autonomous` for phased work, `/prototype` for rapid iteration.
