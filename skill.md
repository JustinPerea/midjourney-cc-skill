---
name: midjourney-cc-skill
description: >
  Midjourney V7 prompt engineering with iterative learning.
  Analyzes references, constructs prompts, scores outputs on 7 dimensions,
  extracts patterns from iterations, and accumulates craft knowledge.
  Use for Midjourney prompt construction, evaluation, or iteration.
license: MIT
metadata:
  author: JustinPerea
  version: "1.0.0"
---

# Midjourney Prompt Learning System

A learning system for Midjourney prompt engineering. It captures what works through iteration, extracts patterns from successes and failures, and applies accumulated craft knowledge to future prompts.

## Architecture Philosophy

This system is designed around a key insight: **you are a multimodal reasoning model**. You don't need complex automated pipelines — you ARE the visual critic, gap analyzer, prompt rewriter, and context manager.

- **You are the VLM critic.** Analyze Midjourney output images directly against the intent/reference and score each dimension. Confirm your assessment with the user.
- **You are the gap analyzer.** Compare output to intent visually and reason about what went wrong.
- **You are the prompt rewriter.** You understand language, visual aesthetics, and MJ's behavior.
- **You handle history natively.** Within a session, you have full conversation context.

**The one thing you can't do natively is remember across sessions.** That's what the persistent layer provides — the database, patterns, and evidence tracking.

## Module Dependencies

| Module | Purpose | Required MCP Servers |
|--------|---------|---------------------|
| Core rules (`core-*`) | Prompt construction, reference analysis, scoring, iteration strategy | None |
| Learning rules (`learn-*`) | Pattern lifecycle, reflection, keyword tracking, knowledge generation | sqlite-simple |
| Automation rules (`auto-*`) | Browser automation for midjourney.com | playwright |

### Getting Started

**Core only** (manual workflow): Load the `core-*` rules. Copy prompts to Midjourney manually.

**Core + Learning** (pattern accumulation): Load `core-*` + `learn-*` rules. Set up sqlite MCP and initialize from `schema.sql`.

**Full system** (automated): Load all rules. Add playwright MCP for browser control.

### MCP Server Setup

```bash
# SQLite (for learning rules)
claude mcp add sqlite-simple -- npx @anthropic-ai/sqlite-simple-mcp mydatabase.db

# Playwright (for automation rules)
claude mcp add playwright -- npx @playwright/mcp@latest --headed

# Initialize the database
sqlite3 mydatabase.db < schema.sql
```

## Rule Categories

| Section | Impact | Prefix | Rules | Description |
|---------|--------|--------|-------|-------------|
| Core Prompt Engineering | CRITICAL | `core-` | 5 | Reference analysis, prompt construction, research, scoring, iteration |
| Learning & Reflection | HIGH | `learn-` | 3 | Data model, pattern lifecycle, reflection workflows |
| Browser Automation | MEDIUM | `auto-` | 2 | Playwright workflows, selectors, error handling |

## Rules Quick Reference

### Core Prompt Engineering (no dependencies)

- **`core-reference-analysis`** — 7-element visual framework, vocabulary translation, reference analysis template
- **`core-prompt-construction`** — V7 prompt structure, keyword best practices, knowledge application check
- **`core-research-phase`** — Coverage assessment, community research workflow, presentation rules
- **`core-assessment-scoring`** — 7-dimension scoring guide, confidence flags, agent limitations
- **`core-iteration-framework`** — Gap analysis, action decision framework, aspect-first approach

### Learning & Reflection (requires sqlite MCP)

- **`learn-data-model`** — Database schema, session structure, directory conventions, ID generation
- **`learn-pattern-lifecycle`** — Confidence graduation, decay, scope rules, knowledge base generation
- **`learn-reflection`** — Session lifecycle, automatic reflection, contrastive analysis, reflection subagent

### Browser Automation (requires playwright MCP)

- **`auto-core-workflows`** — Authentication, prompt submission, smart polling, batch capture, actions
- **`auto-reference-patterns`** — Selector strategy, error handling, timing, grid analysis, image analysis

## Scoring System

All iterations are scored on **7 standard dimensions**: subject, lighting, color, mood, composition, material, spatial_relationships. All 7 are always scored (use 1.0 for "not applicable") to ensure cross-iteration comparability. Scores are presented as preliminary and validated with the user before logging. See `rules/core-assessment-scoring.md`.

## Commands

| Command | Purpose |
|---------|---------|
| `/new-session` | Start a new prompt engineering session with full knowledge application |
| `/research [focus]` | Research community techniques for a specific MJ challenge |
| `/log-iteration` | Log a generation attempt with assessment and feedback |
| `/reflect` | Deep analysis: cross-session patterns, contrastive refinement, contradiction resolution |
| `/show-knowledge [category]` | Display learned patterns, optionally filtered by category |
| `/apply-knowledge <description>` | Show which patterns apply to a given intent and construct a prompt |
| `/validate-pattern [id]` | Mark a pattern as validated or contradicted |
| `/forget-pattern [id]` | Deactivate a pattern that's no longer valid |

## Knowledge Files

Files in `knowledge/` provide reference material and accumulated learning:

- `v7-parameters.md` — Complete MJ V7 parameter reference
- `translation-tables.md` — Visual quality to prompt keyword mappings
- `failure-modes.md` — Diagnostic framework and session-learned failure modes
- `learned-patterns.md` — Auto-generated pattern summaries (populated through use)
- `keyword-effectiveness.md` — Auto-generated keyword ratings (populated through use)
- `prompt-templates/` — Ready-to-use prompt templates by category

## Key Principle

Every pattern must have logged evidence. The system learns from real iteration data, not assumptions. Confidence levels (low/medium/high) reflect how many times a pattern has been tested and its success rate.

## Workflow

1. User starts with `/new-session` describing what they want
2. System queries knowledge base and assesses coverage
3. If coverage is low, system automatically researches community techniques
4. System constructs an informed prompt combining internal knowledge and research
5. Submit to Midjourney — via browser automation or user pastes manually
6. Capture and analyze results
7. Use `/log-iteration` to record what happened
8. Iterate — system recommends next action using the Action Decision Framework
9. Session close triggers automatic reflection to extract patterns
10. Knowledge compounds over time, improving first-attempt success rates

## Full Compiled Reference

For the complete unabridged reference combining all rules, see `AGENTS.md`.
