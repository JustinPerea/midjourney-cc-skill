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
- 9 completed sessions, 58 iterations, 68 patterns, 103 tracked keywords
- Pattern confidence: 4 high, 28 medium, 36 low
- Sessions span: photographic, abstract graphics, complex artistic styles

## Git State
- 2 commits on main, pushed to remote
- Uncommitted: restructured from monolithic to modular rules format
- Untracked: AGENTS.md, rules/, scripts/, metadata.json, reference-images/

## Known Issues
- Context overload when reading full system (~75K+ tokens with startup hooks)
- Startup hook injects ~28K tokens of observation history per conversation
- AGENTS.md (56KB) + all rules = redundant double-load risk
