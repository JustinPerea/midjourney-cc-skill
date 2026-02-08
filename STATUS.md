# Project Status

## What This Is
A Claude Code skill for Midjourney V7 prompt engineering. Iterates on prompts, scores results on 7 dimensions, extracts patterns from successes/failures, and accumulates craft knowledge across sessions.

## Architecture
```
SKILL.md          — Skill definition (entry point, 134 lines)
AGENTS.md         — Compiled rules (generated from rules/, 1058 lines)
rules/            — 10 individual rule files + template/sections
  core-*          — Prompt construction, analysis, scoring, iteration (no deps)
  learn-*         — Pattern lifecycle, reflection, data model (needs sqlite MCP)
  auto-*          — Browser automation workflows (needs playwright MCP)
knowledge/        — V7 parameters, failure modes, translation tables, templates
scripts/build.sh  — Compiles rules/ → AGENTS.md
schema.sql        — Database initialization
mydatabase.db     — Session/pattern/keyword data (sqlite)
```

## Context Loading Guide
- **Quick orientation**: Read this file (STATUS.md)
- **Architecture + workflow**: Read SKILL.md (134 lines)
- **Specific rule details**: Read individual `rules/<name>.md` files as needed
- **Never read AGENTS.md + rules/ together** — AGENTS.md is a compiled copy of rules/
- **Deep review**: Use an Explore subagent to read everything in its own context

## Database State
- 11 sessions (9 success, 2 abandoned), 62 iterations, 77 patterns, 103 tracked keywords
- Pattern confidence: 4 high, 39 medium, 34 low
- 11 normalized categories (merged from 20 — see learn-pattern-lifecycle.md)
- Sessions span: photographic, abstract graphics, complex artistic styles, style codes

## Recent Improvements
- Multi-reference image support (composite analysis from multiple style exemplars)
- Style code knowledge (`--sref` numeric codes, Style Explorer, blending, `--sref random`)
- `/discover-styles` command for browsing and cataloging MJ style codes
- Category normalization (20 → 11 clean categories)
- Pattern promotion pipeline (4 patterns graduated low → medium based on evidence)

## Git State
- 5 commits on main, pushed to remote
- Untracked: reference-images/, sessions/, mydatabase.db

## Known Issues
- Context overload when reading full system (~75K+ tokens with startup hooks)
- Startup hook injects ~28K tokens of observation history per conversation
- AGENTS.md (56KB) + all rules = redundant double-load risk
