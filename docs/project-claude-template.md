# Project CLAUDE.md Template

Copy this to your project root as `CLAUDE.md` and customize for your project.

---

# [Project Name]

## Tech Stack
- Framework: [Next.js / React / Node / etc.]
- Database: [Postgres / Supabase / etc.]
- Package manager: [bun / npm / pnpm]

## Project Structure
```
src/           # or app/, lib/, etc.
├── components/
├── lib/
└── ...
```

## Commands
```bash
# Development
[bun/npm] run dev

# Tests
[bun/npm] run test

# Build
[bun/npm] run build

# Lint
[bun/npm] run lint
```

## Project-Specific Rules

### Import Patterns
- Import database utilities from `@/lib/db` not directly from ORM
- Import UI components from `@/components` not from package directly

### Build Requirements
- DATABASE_URL is required at build time (no "skip" patterns)
- Use `bun` not `npm` in CI/deployment

### Code Patterns
- NEVER add .js extensions to imports (Turbopack incompatible)
- Use server actions for mutations, not API routes
- [Add your project-specific patterns here]

## Known Gotchas
- [List any quirks or traps specific to this project]
- [Things that have caused bugs before]
