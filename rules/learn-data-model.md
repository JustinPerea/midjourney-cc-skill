---
title: "Data Model & Session Structure"
impact: "high"
tags: ["database", "sessions", "schema", "directory"]
---

# Data Model & Session Structure

Database schema overview, core data workflows, session directory conventions, and ID generation. For full schema details, see `schema.sql`.

## System Components

### Database (SQLite via MCP)

The database at `mydatabase.db` contains:

- **sessions**: Each prompt engineering session (intent, reference analysis, status, final prompt)
- **iterations**: Each attempt within a session (prompt, parameters, assessment, feedback, gap analysis)
- **patterns**: Extracted knowledge (problem/solution pairs with evidence and confidence)
- **pattern_evidence**: Links patterns to the sessions/iterations that support or contradict them
- **keyword_effectiveness**: Tracks which keywords reliably produce specific effects
- **session_patterns_applied**: Tracks which patterns were applied in each session (for validation)

### Knowledge Base (Markdown files)

Human-readable files in `knowledge/`:

- `learned-patterns.md` - All active patterns organized by category
- `keyword-effectiveness.md` - Keyword effectiveness ratings
- `failure-modes.md` - Diagnostic framework, common problems, quick fixes, and session-learned failure modes
- `v7-parameters.md` - Complete Midjourney V7 parameter reference
- `translation-tables.md` - Visual quality to prompt keyword mappings
- `prompt-templates/` - Ready-to-use prompt templates by category
- `reference-translations/` - Specific visual concept to prompt mappings from sessions

## Core Data Workflows

### Prompt Construction Queries

When constructing a prompt (see `rules/core-prompt-construction.md` for the full workflow):

1. **Query relevant patterns**:
   ```sql
   SELECT * FROM patterns WHERE is_active = 1 AND category IN (...relevant categories...) ORDER BY confidence DESC, success_rate DESC
   ```
2. **Check keyword effectiveness**:
   ```sql
   SELECT * FROM keyword_effectiveness WHERE intended_effect LIKE '%...%' ORDER BY effectiveness
   ```
3. **Check failure modes**: Read `knowledge/failure-modes.md` for known pitfalls
4. **Log which patterns were applied**:
   ```sql
   INSERT INTO session_patterns_applied (session_id, pattern_id) VALUES (...)
   ```

### Iteration Logging

After each generation attempt, log the iteration:

1. Create a session if one doesn't exist:
   ```sql
   INSERT INTO sessions (id, intent, reference_description, reference_analysis, status)
   VALUES (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(6))), ?, ?, ?, 'active')
   ```

2. Log each iteration:
   ```sql
   INSERT INTO iterations (session_id, iteration_number, prompt, parameters, mj_version, result_assessment, user_feedback, gap_analysis, success, what_worked, what_failed)
   VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
   ```

3. Update session iteration count:
   ```sql
   UPDATE sessions SET total_iterations = total_iterations + 1 WHERE id = ?
   ```

4. On success, update the session:
   ```sql
   UPDATE sessions SET status = 'success', final_successful_prompt = ? WHERE id = ?
   ```

## Session ID Generation

Generate session IDs using:
```sql
lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(6)))
```

## Session Directory Structure

All session images are stored under `sessions/` using the first 8 characters of the session UUID:

```
sessions/
  {session_id_8char}/
    reference.png              # Original reference image (if saved)
    iter-01/
      img-1.png ... img-4.png  # Individual images from the 4-image grid
    iter-02/
      img-1.png ... img-4.png
    ...
```

### Conventions

| Item | Format | Example |
|------|--------|---------|
| Session folder | First 8 chars of UUID | `sessions/a1b2c3d4/` |
| Iteration folder | `iter-{NN}` (zero-padded, matches DB `iteration_number`) | `iter-04/` |
| Individual images | `img-{N}.png` (1-indexed) | `img-1.png` |
| Reference image | `reference.png` in session root | `sessions/a1b2c3d4/reference.png` |

### Reference Image Persistence

The `sessions.reference_image_path` column tracks where the reference is stored. When scoring iterations:
- If the file exists on disk → load it for direct visual comparison (preferred)
- If not available → fall back to text-based `reference_analysis` JSON
- Flag which method was used in every assessment

## Related Rules

- `core-prompt-construction` — Uses queries from this rule to apply knowledge
- `core-assessment-scoring` — Stores scores in the iterations table
- `learn-reflection` — Reads iteration data for pattern extraction
