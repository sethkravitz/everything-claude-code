# Hard Stops

Before ANY commit, verify ALL. Failing ANY = rejected.

## Commit Blockers

1. **NO TODOs/FIXMEs** in committed code
2. **NO console.log** (except logging utilities)
3. **NO placeholder implementations**
4. **NO dead/commented-out code**
5. **NO secrets in code** (env vars only)
6. **NO untyped `any`** without justification comment

## Pre-Commit Verification

```bash
grep -rE "TODO|FIXME|console\.log" .      # Must return nothing (adjust path per project)
npx tsc --noEmit                          # Must pass (if TypeScript project)
npm run lint                              # Must pass (if lint configured)
```

## After Changes

- After signature changes → grep all callers
- After deleting files → grep all references
- After bug fixes → add regression test

## Universal Rules

- NEVER blame "pre-existing errors" - fix ALL errors you see
- NEVER add features not in the brief
