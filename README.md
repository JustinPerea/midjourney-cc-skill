# Midjourney Prompt Learning System

A Claude Code skill that learns Midjourney prompt engineering through iteration. It captures what works, extracts patterns from successes and failures, and applies accumulated craft knowledge to future prompts.

Compatible with the [Vercel agent-skills](https://github.com/vercel/agent-skills) format — installable via `npx skills add`.

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
├── SKILL.md                     # Vercel agent-skills entry point — skill definition,
│                                #   architecture, rule index, workflow overview
├── CLAUDE.md                    # Claude Code router — points to SKILL.md and rules/
├── AGENTS.md                    # Compiled full reference (auto-generated from rules/)
├── metadata.json                # Skill metadata (version, author, references)
├── schema.sql                   # Database setup script — creates the 6 tables for
│                                #   sessions, iterations, patterns, and keyword data
├── rules/
│   ├── _sections.md             # Section definitions (core, learn, auto)
│   ├── _template.md             # Template for creating new rules
│   ├── core-reference-analysis.md   # 7-element visual framework, vocabulary translation
│   ├── core-prompt-construction.md  # V7 prompt structure, knowledge application check
│   ├── core-research-phase.md       # Coverage assessment, community research workflow
│   ├── core-assessment-scoring.md   # 7-dimension scoring guide, agent limitations
│   ├── core-iteration-framework.md  # Gap analysis, action decisions, aspect-first approach
│   ├── learn-data-model.md          # Database schema, session structure, ID generation
│   ├── learn-pattern-lifecycle.md   # Confidence graduation, decay, knowledge generation
│   ├── learn-reflection.md          # Session lifecycle, automatic reflection, subagent
│   ├── auto-core-workflows.md       # Browser automation sequences for midjourney.com
│   └── auto-reference-patterns.md   # Selector strategy, error handling, image analysis
├── knowledge/
│   ├── v7-parameters.md         # Complete Midjourney V7 parameter reference (static)
│   ├── translation-tables.md    # Visual quality → prompt keyword mappings (static)
│   ├── prompt-templates/        # Ready-to-use prompt templates by category (static)
│   ├── official-docs.md         # Maps official MJ doc pages to internal files (freshness layer)
│   ├── failure-modes.md         # Diagnostic framework + session-learned failures (mixed)
│   ├── learned-patterns.md      # Auto-generated pattern summaries (populated through use)
│   └── keyword-effectiveness.md # Auto-generated keyword ratings (populated through use)
├── scripts/
│   └── build.sh                 # Compiles rules/ → AGENTS.md
├── .claude/commands/            # Slash command definitions (/new-session, /reflect, etc.)
└── LICENSE
```

## Rule Categories

| Section | Impact | Prefix | Rules | Dependencies |
|---------|--------|--------|-------|-------------|
| **Core Prompt Engineering** | CRITICAL | `core-` | 5 | None — works standalone |
| **Learning & Reflection** | HIGH | `learn-` | 3 | sqlite MCP server |
| **Browser Automation** | MEDIUM | `auto-` | 2 | playwright MCP server |

## Quick Start

### Level 1: Core Only (no setup)

Read `SKILL.md` and the `core-*` rules. Everything you need to construct effective Midjourney V7 prompts:
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
| `/discover-styles` | Browse and catalog MJ style codes from the Style Explorer |
| `/validate-pattern [id]` | Mark a pattern as validated or contradicted |
| `/forget-pattern [id]` | Deactivate a pattern |

## Knowledge Files

Files in `knowledge/` fall into two categories:

**Static reference** — ships with content, useful immediately:
- `v7-parameters.md` — every MJ V7 parameter with syntax, defaults, and tips
- `official-docs.md` — maps all official MJ doc pages to internal files for freshness checks
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

## Building AGENTS.md

The compiled reference is auto-generated from rule files:

```bash
./scripts/build.sh
```

This strips YAML frontmatter from each rule file and concatenates them under section headers.

## License

MIT
