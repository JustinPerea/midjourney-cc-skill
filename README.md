# Midjourney Prompt Learning System

A Claude Code skill that learns Midjourney prompt engineering through iteration. It captures what works, extracts patterns from successes and failures, and applies accumulated craft knowledge to future prompts.

## How It Works

```
You describe what you want
  → System applies learned patterns + researches gaps
    → Constructs an informed prompt
      → Submits to Midjourney (optional automation)
        → Scores the output on 7 dimensions
          → Extracts patterns from what worked and what didn't
            → Knowledge compounds over time
```

Each session feeds the learning loop. The system tracks keyword effectiveness, failure modes, and technique patterns with evidence-based confidence levels. Over time, first-attempt success rates improve as the knowledge base grows.

## Architecture

The system is split into three modules. Use only what you need:

| Module | What it does | Dependencies |
|--------|-------------|--------------|
| **`skill.md`** | Core prompt engineering: reference analysis, prompt construction, scoring, iteration strategy | None |
| **`learning.md`** | Pattern tracking: reflection, keyword effectiveness, confidence graduation, knowledge base generation | sqlite MCP |
| **`automation.md`** | Browser control: submit prompts, capture results, perform upscale/variation actions on midjourney.com | playwright MCP |

## Quick Start

### Level 1: Core Only (no setup)

Just read `skill.md`. It contains everything you need to construct effective Midjourney V7 prompts:
- Reference analysis framework (7 formal art elements)
- Vocabulary translation layer (visual analysis → MJ keywords)
- Prompt structure best practices
- Assessment scoring guide (7 dimensions)
- Gap analysis and iteration strategy

Copy prompts to Midjourney manually.

### Level 2: Core + Learning

Add persistent learning across sessions.

```bash
# 1. Install the sqlite MCP server
claude mcp add sqlite-simple -- npx @anthropic-ai/sqlite-simple-mcp mydatabase.db

# 2. Initialize the database
sqlite3 mydatabase.db < schema.sql
```

Now the system tracks patterns, keywords, and failure modes. Use `/reflect` for deep cross-session analysis.

### Level 3: Full Automation

Add browser control for hands-free iteration.

```bash
# Add the playwright MCP server
claude mcp add playwright -- npx @playwright/mcp@latest --headed
```

The system submits prompts directly to midjourney.com, waits for generation, captures all 4 images, scores them, and recommends the next action. Log in manually on first use — cookies persist.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (CLI)
- A Midjourney subscription (for generating images)
- Node.js (for MCP servers, if using Level 2+)
- SQLite3 CLI (for database setup, if using Level 2+)

## Commands

| Command | Purpose |
|---------|---------|
| `/new-session` | Start a new session with full knowledge application |
| `/log-iteration` | Log a generation attempt with scoring and gap analysis |
| `/reflect` | Cross-session pattern analysis and knowledge extraction |
| `/research [focus]` | Research community techniques for a specific challenge |
| `/show-knowledge [category]` | Display learned patterns |
| `/apply-knowledge <description>` | Get pattern-informed prompt for a description |
| `/validate-pattern [id]` | Mark a pattern as validated or contradicted |
| `/forget-pattern [id]` | Deactivate a pattern |

## Knowledge Files

The `knowledge/` directory contains reference material and learned data:

| File | Type | Contents |
|------|------|----------|
| `v7-parameters.md` | Static reference | Complete MJ V7 parameter guide |
| `translation-tables.md` | Static reference | Visual quality → prompt keyword mappings |
| `prompt-templates/` | Static reference | Ready-to-use templates by category |
| `failure-modes.md` | Mixed | Diagnostic framework (static) + session-learned failures (dynamic) |
| `learned-patterns.md` | Dynamic | Auto-generated from pattern database |
| `keyword-effectiveness.md` | Dynamic | Auto-generated from keyword tracking |

Dynamic files are regenerated after each reflection. They start empty and populate through use.

## The Learning Loop

1. **Start**: `/new-session` — describe your intent, share a reference image
2. **Apply**: System queries patterns, keywords, and failure modes to construct an informed prompt
3. **Generate**: Submit to Midjourney (automated or manual)
4. **Score**: 7-dimension assessment with user validation
5. **Iterate**: System recommends Vary Subtle/Strong vs. prompt edit based on gap analysis
6. **Reflect**: Session close auto-extracts patterns; `/reflect` does deeper cross-session analysis
7. **Accumulate**: Patterns graduate from low → medium → high confidence with evidence

## License

MIT
