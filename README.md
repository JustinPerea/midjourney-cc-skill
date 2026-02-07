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

## Repository Structure

```
.
├── CLAUDE.md                  # Entry point — Claude reads this first to understand the system
├── skill.md                   # Core prompt engineering: how to analyze references, build
│                              #   prompts, score outputs, and iterate. Works standalone.
├── learning.md                # Pattern tracking: how the system remembers what works across
│                              #   sessions. Database schema, reflection, confidence graduation.
├── automation.md              # Browser automation: how to control midjourney.com directly —
│                              #   submit prompts, poll for results, capture images, run actions.
├── schema.sql                 # Database setup script — run this once to create the 6 tables
│                              #   that store sessions, iterations, patterns, and keyword data.
├── knowledge/
│   ├── v7-parameters.md       # Complete Midjourney V7 parameter reference (static)
│   ├── translation-tables.md  # Visual quality → prompt keyword mappings (static)
│   ├── prompt-templates/      # Ready-to-use prompt templates by category (static)
│   ├── failure-modes.md       # Diagnostic framework + session-learned failures (mixed)
│   ├── learned-patterns.md    # Auto-generated pattern summaries (populated through use)
│   └── keyword-effectiveness.md  # Auto-generated keyword ratings (populated through use)
├── .claude/commands/          # Slash command definitions (/new-session, /reflect, etc.)
└── LICENSE
```

The three core modules can be adopted independently:

| Module | What it does | Requires |
|--------|-------------|----------|
| **`skill.md`** | Reference analysis, prompt construction, 7-dimension scoring, iteration strategy | Nothing — works standalone |
| **`learning.md`** | Pattern extraction, keyword tracking, confidence graduation, knowledge base generation | sqlite MCP server |
| **`automation.md`** | Submit prompts, poll for generation, capture 4-image grids, run upscale/vary actions | playwright MCP server |

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

Files in `knowledge/` fall into two categories:

**Static reference** — ships with content, useful immediately:
- `v7-parameters.md` — every MJ V7 parameter with syntax, defaults, and tips
- `translation-tables.md` — maps visual qualities (e.g., "warm side lighting") to MJ keywords
- `prompt-templates/` — copy-paste prompt skeletons for hero backgrounds, 3D abstract, product shots

**Dynamic / learned** — starts empty, populates through use:
- `learned-patterns.md` — pattern summaries auto-generated from the database after `/reflect`
- `keyword-effectiveness.md` — keyword ratings auto-generated from iteration data
- `failure-modes.md` (bottom section) — session-learned failure modes appended during reflection

The top half of `failure-modes.md` is a static diagnostic framework — decision trees for common problems organized by dimension (subject, composition, color, etc.).

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
