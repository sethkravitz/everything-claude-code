# Session End

**Purpose:** Clean session closeout - kill dev servers, commit work, document for next session.

---

## Phase 1: Cleanup

### Kill Dev Servers (Ports 3000-3005 only)

```bash
# Find and kill processes on dev ports
for port in 3000 3001 3002 3003 3004 3005; do
  pid=$(lsof -ti:$port 2>/dev/null)
  if [ -n "$pid" ]; then
    echo "Killing process on port $port (PID: $pid)"
    kill $pid 2>/dev/null
  fi
done
```

**Report:** Which ports had processes, which were killed.

---

## Phase 2: Git Status

```bash
git status --short
git diff --stat
```

**Report:**
- Files modified: [count]
- Files created: [count]
- Staged changes: [yes/no]

---

## Phase 3: Quality Check (Quick)

```bash
npx tsc --noEmit 2>&1 | head -10
npm run lint -- --quiet 2>&1 | head -10
```

**Report:**
- Type errors: [count or "none"]
- Lint errors: [count or "none"]

If errors exist, ask: "Fix before committing, or commit anyway?"

---

## Phase 4: Commit (Only If User Approves)

**Ask:**
```
Ready to commit?
- [X] files changed
- Quality: [status]

Options:
1. Yes, commit all
2. Yes, commit specific files only
3. No, leave uncommitted
```

**If yes:**
```bash
git add [files]
git commit -m "$(cat <<'EOF'
[type]: [description]

[body if needed]

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

---

## Phase 5: Handoff Summary

```
SESSION SUMMARY

✅ COMPLETED
- [What was finished]

⏳ INCOMPLETE
- [What's half-done]

⚠️ ISSUES
- [Any problems]

➡️ NEXT SESSION
- [What to work on next]
```

---

## Rules

- **DO NOT commit without permission**
- **DO NOT push without permission**
- **DO NOT kill processes outside 3000-3005**
- **DO provide honest status** (broken code = say so)
